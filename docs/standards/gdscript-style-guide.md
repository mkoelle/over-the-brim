# GDScript Style Guide

Follow Godot official style conventions with project-specific additions.

See AGENTS.md for naming conventions and coding rules.

## Enforcement

Formatting and lint rules are enforced by [gdtoolkit](https://github.com/Scony/godot-gdscript-toolkit)
(`gdformat` + `gdlint`), default config (100-char lines, Godot's official
class-member ordering). Scoped to `scripts/` and `tests/` — `addons/` is
vendored, not reformatted.

```bash
task fmt         # reformat in place
task fmt:check   # check only, no writes (what CI runs)
task lint        # gdlint
```

CI (`.github/workflows/ci.yml`) fails on either check. Run `task setup` once
to install `gdformat`/`gdlint` locally (needs Python/pip).

Details to be expanded as patterns emerge during development.
