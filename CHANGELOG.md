# Changelog

All notable changes to this project are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows the tag pushed to trigger a release (see
`docs/standards/versioning.md`); the same value is set in
`project.godot`'s `application/config/version` and mirrored into
`export_presets.cfg`'s per-platform version fields at release time.

## [Unreleased]

## [0.0.2-alpha] - 2026-09-14

### Added

- **Drivable prototype milestone** (Phase A, Iteration 01 — Guardrail 3's
  "1-Car Fun" rule): input map + per-device `InputSource` (Architecture
  Decision 01), data-driven `VehicleStats` resource, `VehicleController`
  (arcade accel/brake/steer/drift, partial air control on
  `CharacterBody3D`), `test_track.tscn` sandbox, `ChaseCamera`, and
  `main.tscn` wired end-to-end — running the project spawns a drivable car
  on the test track with a following camera.
- Debug HUD toggle (F3): `GameConfig.debug_mode` gates a live
  speed/throttle/steer/drift/FPS readout
  (`docs/standards/manual-testing.md`).
- Real GdUnit4 coverage for `VehicleController` (acceleration, max-speed
  clamp, NaN guard) and `DebugOverlay`.
- macOS `.icns` and Android adaptive launcher icons, closing the icon gap
  left open by ADR-007 (Windows-only icon fix).
- `application/config/version` in `project.godot` as the version
  source of truth, synced to the current release tag.
- `docs/standards/versioning.md` and `docs/standards/branching.md`.
- ADR-009 through ADR-012: third-party addon selection (netfox,
  Controller Icons, LimboAI — each deferred to its own trigger milestone)
  and a standing self-implementation-boundary policy.
- `Taskfile.yml`: local/CI parity runner (`task ci`, `task verify`,
  `task run`, `task export[:platform]`, `task clean`, and more).
- `gdformat`/`gdlint` (gdtoolkit) enforcement on first-party GDScript,
  plus a `pre-commit` hook (`task setup`) running both on every commit.
- `.gitattributes` for Godot-appropriate line-ending and binary handling.
- `.github/dependabot.yml` for automatic GitHub Actions version-update PRs.
- PR test reporting (`dorny/test-reporter`) and failure-artifact upload
  for CI's QC job.

### Changed

- CI now runs its QC pass on every branch push, not just `main` — but
  only a `main` push or a pull request can fail/alert; a bare
  feature-branch push is non-blocking. Job renamed `test` → `qc` to match
  its actual scope (import, parse-check, tests, format, lint).
- Vehicle steering/camera/air-control tuned against kart-racer genre
  convention: fixed inverted reverse-steering, fixed a floaty fall bug,
  restored partial air control.
- Test track reworked with full perimeter walls and inner walls as
  obstacles; track geometry converted to `CSGBox3D`.

## [0.0.1-alpha] - 2026-09-09

### Added

- Initial project scaffolding: Godot 4.7 project, main scene, autoloads
  (`EventBus`, `GameConfig`).
- CI pipeline (import check, script-error check, GdUnit4 test run).
- Release pipeline (tag-triggered multi-platform export + GitHub Release).
- GdUnit4 test framework, vendored at `addons/gdUnit4/`.
- Windows executable icon.
- Project documentation set: architecture overview, design docs, coding
  standards, ADRs.

See `docs/adr/ADR-007-build-test-and-release-pipeline.md` for the detailed
history of what it took to get the pipeline working.
