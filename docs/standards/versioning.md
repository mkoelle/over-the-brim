# Versioning

## Source of truth

The git tag drives a release (`release.yml` triggers on `v*.*.*` push).
`project.godot`'s `application/config/version` and the per-platform version
fields in `export_presets.cfg` must be kept in sync with the tag being
released — they are separate files Godot doesn't cross-reference
automatically, so this is a manual step until it's worth scripting.

| Location | Field | Format |
| --- | --- | --- |
| `project.godot` | `application/config/version` | `X.Y.Z` or `X.Y.Z-alpha` |
| `export_presets.cfg` (Windows) | `application/file_version`, `application/product_version` | `X.Y.Z.0` (numeric only — Windows PE version resource rejects suffixes) |
| `export_presets.cfg` (macOS) | `application/short_version`, `application/version` | `X.Y.Z` (numeric only — `CFBundleShortVersionString`/`CFBundleVersion`) |
| `export_presets.cfg` (Android) | `version/name` | `X.Y.Z` or `X.Y.Z-alpha` (free-form display string) |
| `export_presets.cfg` (Android) | `version/code` | integer, increment every release regardless of version name |
| `CHANGELOG.md` | section heading | `[X.Y.Z-suffix] - YYYY-MM-DD` |

## Release process

1. Update the version in the four locations above.
2. Move `[Unreleased]` entries in `CHANGELOG.md` into a new dated section.
3. Commit, then tag: `git tag vX.Y.Z-suffix && git push --tags`.
4. `release.yml` exports all platforms and publishes a GitHub Release.

Pre-1.0, use `-alpha` / `-beta` suffixes freely. Suffixes are dropped from
the two numeric-only fields above but kept everywhere else.
