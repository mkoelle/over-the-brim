# ADR-007: Build, Test, and Release Pipeline

**Status:** Accepted

**Date:** 2026-09-09

### Context

The project had no export presets, no app icon, no automated testing, and no
build/release automation. `docs/standards/testing-standards.md` and
`.agents/testing.md` both left the test framework as "To be decided via ADR"
(candidates: GdUnit4, GUT). `AGENTS.md` blanket-forbade committing
`export_presets.cfg`, which is incompatible with headless CI export — that
file holds platform/build configuration, not secrets, unless a developer
types signing credentials into the export dialog.

Needed: a foundation that is more than Godot's defaults but does not pull in
tooling the project isn't ready to use yet (no gameplay code exists; no
custom render pipeline; no live-ops backend).

### Decision

- **Test framework: GdUnit4.** Chosen over GUT for its scene-runner frame
  simulation (`simulate_frames`), which fits testing physics/frame-based
  vehicle behavior better than GUT's manual frame stepping, and its official
  GitHub Action, which reduces custom CI glue. Vendored at `addons/gdUnit4/`
  (v6.2.0), registered in `project.godot`'s `[editor_plugins] enabled`.
  Verified locally (Godot 4.7.2): `godot --headless -s
  addons/gdUnit4/bin/GdUnitCmdTool.gd -a tests --ignoreHeadlessMode -c` runs
  and exits with the correct non-zero code on a failing test, and exits 0
  cleanly when suites pass. One quirk found during verification: with **zero**
  test suites present, the runner never quits on its own (it polls
  indefinitely) — `--quit-after 1` looked like a fix but corrupts real test
  runs (crashes the engine with SIGSEGV mid-suite, since it tears down the
  process after exactly one frame regardless of whether async test execution
  has finished). The real fix is a shell-level `timeout` in `ci.yml`, which
  only matters until `tests/` holds a real suite.
- **CI (`ci.yml`):** on push/PR to `main` — headless import
  (`--headless --editor --quit`), a headless run-and-quit pass to surface
  GDScript parse/script errors, and GdUnit4 test execution (skipped with a
  notice until the addon is installed).
- **Release (`release.yml`):** triggered by pushing a `v*.*.*` tag. Uses the
  `barichello/godot-ci` Docker image (bundles export templates + Android SDK)
  to export Windows, Linux, macOS, and Android in parallel matrix jobs, zips
  each, and publishes them to a GitHub Release via `softprops/action-gh-release`.
  `fail-fast: false` on the matrix — the first real tag push (`v0.0.1-alpha`)
  had Linux fail and cascade-cancel the other three platforms before they even
  ran, which lost the diagnostic signal from all of them at once.
  An "Ensure Godot export templates" step now runs before every export: if
  `~/.local/share/godot/export_templates/<version>.stable/` isn't already
  populated (checked, not assumed), it downloads the official
  `Godot_v<version>-stable_export_templates.tpz` from the godotengine/godot
  GitHub release and unpacks it. This removes the dependency on
  `barichello/godot-ci`'s bundled templates matching the pinned engine patch
  exactly — the same failure mode reproduced locally against a bare Godot
  4.7.2 install (`ERROR: Cannot export project with preset "Linux" ... No
  export template found`) even though the preset config itself was verified
  correct. The archive is ~1.2GB; the step is a no-op (just an `ls` check)
  whenever the image's own templates are already usable, so this only costs
  download time on the fallback path.
- **"Restore baked Godot config" step + `permissions: contents: write` +
  `concurrency` guard.** The `v0.0.1-alpha` re-run (after the
  `fail-fast`/template fixes above) still failed all four platforms.
  Root-caused by pulling `barichello/godot-ci:4.7.2` locally (`podman`) and
  reproducing each failure directly against the same image — including
  replicating GitHub's actual execution model (one long-lived container,
  each workflow step as a *separate* `docker exec` call), since an earlier
  single-shell reproduction had missed a step-boundary issue entirely:
  - **All four**, root problem: GitHub Actions overrides `HOME` to an empty
    `/github/home` for `container:` jobs and **ignores `container.env.HOME`**
    — confirmed by inspecting the actual `docker create` command GitHub
    generates, which hardcodes `-e HOME=/github/home` regardless of what's
    set in the workflow. So `container.env.HOME=/root`, tried first, does
    nothing. The image bakes a working `/root/.config/godot/
    editor_settings-4.7.tres` (java_sdk_path, android_sdk_path,
    debug_keystore) and `/root/.local/share/godot/export_templates/`, both
    invisible under the real `HOME`. Fixed by copying both from `/root` into
    `$HOME` in a new first step, rather than fighting the `HOME` override.
  - **Android** specifically failed on `A valid Java SDK path is required in
    Editor Settings.` until the settings copy above was in place.
  - **macOS + Android**: `ETC2/ASTC texture compression is required` /
    `Cannot export for universal or arm64 if ETC2 ASTC texture format is
    disabled`. This is a **project setting**
    (`rendering/textures/vram_compression/import_etc2_astc` in
    `project.godot`), not an export-preset option — the
    `texture_format/etc2_astc` key that already existed in
    `export_presets.cfg` was a red herring for a different, unrelated
    setting. Fixed by adding `[rendering] textures/vram_compression/
    import_etc2_astc=true` to `project.godot`.
  - **All four platforms**, still unresolved at the engine level: exit 132,
    `handle_crash: Program crashed with signal 11` (`ERROR: FATAL: Index
    p_index = 1 is out of bounds (size() = 0).` at `cowdata.h:197`)
    immediately followed by `Illegal instruction`, happening *after*
    `savepack` reaches 100% (`[ DONE ] savepack`) — the export artifact
    (`.exe`/`.x86_64`/`.zip`/`.apk` + `.pck` as applicable) is already
    written to disk correctly before the crash, every single time it's been
    observed. Was initially (wrongly) diagnosed as an `adb`-shutdown issue —
    it was preceded by `cannot connect to daemon at tcp:5037: Connection
    refused` on the first two attempts, and disabling `shutdown_adb_on_exit`
    (above) does eliminate that log line. But a subsequent run with that fix
    in place, and *no* "connection refused" line anywhere in the log, still
    crashed identically on GitHub's real x86_64 runners. It has also never
    reproduced locally under `podman` on this arm64 Mac (QEMU-emulated
    amd64) with otherwise-identical commands against the identical image —
    so it may be a real x86_64-hardware-specific Godot 4.7.2 bug that QEMU's
    translation happens not to trigger. Root cause left unresolved; the
    pragmatic fix is to stop trusting Godot's exit code and check for the
    actual artifact instead — `matrix.check` names the expected output file
    per platform, and the `Export (desktop)`/`Export (android)` steps treat
    the step as failed only when that file is genuinely missing (`|| true`
    on the godot invocation, then `[ -s "$check" ]`). Revisit if a later
    Godot patch fixes this, or if it starts producing a missing/corrupt
    artifact instead of a benign post-write crash.
  - Two gaps caught by review before this ever reached a real release
    attempt: the `release` job had no `permissions: contents: write`, which
    `softprops/action-gh-release` needs to create the release and upload
    assets under a repo with non-permissive default workflow permissions —
    added at the workflow level. And repeated re-tags during this debugging
    session had no guard against overlapping runs — added
    `concurrency: {group: release-${{ github.ref }}, cancel-in-progress: true}`.
  Windows, Linux, and macOS (Android debug-signed) all export clean
  end-to-end against `barichello/godot-ci:4.7.2` locally via `podman` —
  using a detached container plus per-step `exec` calls to match GitHub's
  real execution model, not a single combined shell — with zero crashes
  observed there; the crash is specific to GitHub's actual runners and is
  now tolerated rather than reproduced-and-fixed.
- **Targets: Desktop (Win/Linux/macOS) + Android**, no iOS/Web yet — nothing
  in the design docs needs those; add when a concrete need exists (e.g. the
  spectator companion app from ADR-006 might justify Web/mobile later).
- **`export_presets.cfg` is now committed.** It contains platform/build
  identity (product name, bundle/package IDs, architectures) — no secrets.
  Signing credentials are never written to it: `release.yml` injects an
  Android release keystore + password from `ANDROID_KEYSTORE_BASE64`,
  `ANDROID_KEY_ALIAS`, `ANDROID_KEYSTORE_PASSWORD` GitHub Secrets via `sed`
  at build time, into a keystore file that never leaves the CI runner. If
  those secrets aren't set, the Android job falls back to a debug-signed APK
  so the pipeline still runs end-to-end before real signing is configured.
  `.gitignore` now excludes `*.keystore`, `*.jks`, and `/build/` instead of
  the preset file itself.
- **App icon:** `icon.svg` at the project root (Godot convention), referenced
  via `config/icon` in `project.godot`. Hand-authored placeholder (flat
  top-hat/wheel motif) — swap for real art in `assets/art/ui/` once available;
  update the `config/icon` path and `export_presets.cfg`'s
  `application/icon` / `launcher_icons/*` fields to match.
- `project.godot`'s `config/features` and the CI/release pins (`GODOT_VERSION`,
  `barichello/godot-ci` tag) must match the actually-installed engine — this
  was briefly out of sync (a `mise`-managed `4.6.2` shim shadowed the intended
  `4.7.2` from Homebrew on PATH) and corrected to `"4.7"` / `4.7.2`. Confirm
  which `godot` resolves first on PATH before touching this again.
- **No double-zipping macOS/Android.** The `v0.0.1-alpha` macOS asset failed
  to unzip on download. Cause: Godot's macOS export already produces a single
  `.zip` (the `.app` bundle), and the release workflow's old single "Zip
  artifact" step re-zipped that already-compressed file into a second zip
  unconditionally for every platform — Android's already-signed `.apk` got
  the same treatment. Matrix gained a `zip: true/false` field (`true` for
  Windows/Linux, which are genuinely two loose files needing bundling; `false`
  for macOS/Android, which are already single distributable files) — the
  packaging step now copies those straight through instead of re-compressing.
  Android's artifact extension also changed from `.zip` to the correct `.apk`.
- **Action versions.** `actions/upload-artifact@v4` and
  `actions/download-artifact@v4` were both several majors behind
  (latest: v7 and v8 respectively — CI logs were already flagging the v4/Node
  20 deprecation), and `softprops/action-gh-release@v2` had a v3. Checked each
  major version's changelog for breaking changes before bumping — none apply
  to this workflow's usage (v5-era artifact-action bumps are Node-runtime
  only; the one real breaking change, v5's "inconsistent path behavior for
  single artifact downloads by ID," only affects downloading a single named
  artifact by ID, not this workflow's `merge-multiple: true` download-all).
  `actions/checkout@v7` and `chickensoft-games/setup-godot@v2` were already
  on their latest major.
- **macOS ad-hoc codesigning** (`codesign/codesign=1` in `export_presets.cfg`,
  up from `0`/disabled). The `v0.0.1-alpha` macOS asset showed "'Over The
  Brim' is damaged and can't be opened" on a real Mac after downloading via
  Chrome — modern macOS Gatekeeper refuses a completely unsigned app outright
  (worse than the "unidentified developer" warning a signed-but-unnotarized
  app gets) once the browser's quarantine attribute is set. Since the binary
  is `universal` (includes an arm64 slice), this isn't just a download
  warning either — Apple Silicon requires at least an ad-hoc signature to
  execute unsigned code at all. Godot's built-in signer handles this without
  any Apple tooling or account, cross-platform: verified locally that the
  Linux container (no `codesign` binary present) produces a
  `Contents/_CodeSignature/CodeResources` in the exported `.app` with
  `codesign/codesign=1`. This is still not a Developer ID signature and the
  app is not notarized — right-click-Open (or a first-run Gatekeeper prompt)
  may still be needed. Full notarization requires an Apple Developer Program
  membership and is out of scope for this stage; revisit if/when the project
  ships beyond internal alpha testing.

### Consequences

Easier: contributors get a working export/build path immediately; CI catches
parse errors and (once GdUnit4 is installed) regressions before merge;
tagging a release is now a one-command action (`git tag v0.1.0 && git push
--tags`) instead of a manual per-platform export.

Harder: `export_presets.cfg` now needs updating by hand (or via the editor's
Export dialog, then re-diffed) whenever a new platform or icon path is added,
since it's a tracked file. Android release builds remain debug-signed until
someone provisions a real keystore and sets the three GitHub Secrets above.

### Alternatives Considered

- **GUT** instead of GdUnit4 — larger community/tutorial base, but weaker
  fit for physics/frame-based test scenarios and requires more hand-rolled
  CI wiring. Revisit if GdUnit4's frame simulation proves insufficient.
- **Manual Android SDK + export template setup** in CI instead of
  `barichello/godot-ci` — more control, much more workflow code to maintain
  for a project not yet shipping to Android. Rejected as over-the-top for
  this stage.
- **`workflow_dispatch`-only releases** instead of tag-push — considered,
  but tag-push keeps a durable, conventional record of what was released and
  when.
- **Leaving `export_presets.cfg` gitignored**, generating it fresh in CI from
  a script — avoids a tracked config file but means the file the editor
  round-trips locally is never the one CI actually uses, inviting drift.
  Rejected in favor of committing it and being disciplined about never
  hand-typing secrets into it.
