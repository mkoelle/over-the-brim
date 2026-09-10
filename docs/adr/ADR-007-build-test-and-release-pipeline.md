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
- **`container.env.HOME=/root`.** The `v0.0.1-alpha` re-run (after the
  `fail-fast`/template fixes above) still failed all four platforms with three
  distinct errors, root-caused by pulling `barichello/godot-ci:4.7.2` locally
  (`podman`) and reproducing each one directly against the same image:
  - **Android**: `A valid Java SDK path is required in Editor Settings.`
    GitHub Actions overrides `HOME` to an empty `/github/home` for `container:`
    jobs by default. The image bakes a working `/root/.config/godot/
    editor_settings-4.7.tres` (java_sdk_path, android_sdk_path) *and*
    `/root/.local/share/godot/export_templates/4.7.2.stable/` — both invisible
    once `HOME` points elsewhere, which is also why the template-download
    step above was actually firing in CI despite the image already having
    them. Confirmed by reproducing the exact error locally with
    `HOME=/github/home` and watching it disappear with `HOME=/root`.
  - **macOS + Android**: `ETC2/ASTC texture compression is required` /
    `Cannot export for universal or arm64 if ETC2 ASTC texture format is
    disabled`. This is a **project setting**
    (`rendering/textures/vram_compression/import_etc2_astc` in
    `project.godot`), not an export-preset option — the
    `texture_format/etc2_astc` key that already existed in
    `export_presets.cfg` was a red herring for a different, unrelated
    setting. Fixed by adding `[rendering] textures/vram_compression/
    import_etc2_astc=true` to `project.godot`.
  - **Windows + Linux**: exit 132, `handle_crash: Program crashed with signal
    11` immediately followed by `Illegal instruction`, happening *after*
    `savepack` reaches 100% (`[ DONE ] savepack`) — the export artifact
    (`OverTheBrim.x86_64` / `.exe` + `.pck`) is already written to disk
    correctly before the crash. Preceded every time by `cannot connect to
    daemon at tcp:5037: Connection refused`. Because an Android preset is
    configured, Godot's Android export plugin loads and polls `adb`
    regardless of which platform is being exported; a refused connection
    during its post-export hook is what triggers the fatal index error.
    Root-caused and fixed by adding a `Start adb server` step
    (`adb start-server`) before any export — reproduced the crash locally
    without it and confirmed it disappears with it, on this exact image.
  All four platforms (Windows, Linux, macOS, Android debug-signed) now export
  clean end-to-end against `barichello/godot-ci:4.7.2` locally via `podman`,
  verified before touching CI again rather than guessing through further
  tag-push cycles.
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
