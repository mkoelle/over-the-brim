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
  GitHub Action, which reduces custom CI glue. The addon itself is not
  vendored by this ADR — install it via the AssetLib/editor into
  `addons/gdUnit4/` when the first tests are written; `.github/workflows/ci.yml`
  already checks for that directory and runs tests if present.
- **CI (`ci.yml`):** on push/PR to `main` — headless import
  (`--headless --editor --quit`), a headless run-and-quit pass to surface
  GDScript parse/script errors, and GdUnit4 test execution (skipped with a
  notice until the addon is installed).
- **Release (`release.yml`):** triggered by pushing a `v*.*.*` tag. Uses the
  `barichello/godot-ci` Docker image (bundles matching export templates +
  Android SDK) to export Windows, Linux, macOS, and Android in parallel
  matrix jobs, zips each, and publishes them to a GitHub Release via
  `softprops/action-gh-release`.
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
