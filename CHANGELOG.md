# Changelog

All notable changes to this project are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows the tag pushed to trigger a release (see
`docs/standards/versioning.md`); the same value is set in
`project.godot`'s `application/config/version` and mirrored into
`export_presets.cfg`'s per-platform version fields at release time.

## [Unreleased]

### Added

- macOS `.icns` and Android adaptive launcher icons, closing the icon gap
  left open by ADR-007 (Windows-only icon fix).
- `application/config/version` in `project.godot` as the version
  source of truth, synced to the current release tag.
- `docs/standards/versioning.md` and `docs/standards/branching.md`.

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
