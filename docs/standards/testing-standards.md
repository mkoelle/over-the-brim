# Testing Standards

## Bug Reports

Require:
- reproduction steps
- expected behavior
- actual behavior

## Test Framework

GdUnit4 (ADR-007). Install via AssetLib/editor into `addons/gdUnit4/`.
Run via `task test` (see `Taskfile.yml`), or raw:
`godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a test --ignoreHeadlessMode -c`.
CI (`.github/workflows/ci.yml`) runs the same `task test` automatically once
the addon is present.

No code coverage measurement yet — see STATE.md's deferred tooling section
for why (`gdUnit4-coverage` is beta/capped/closed-source as of 2026-09-14).

## Test Categories

- **Unit**: Isolated logic (scoring, bracket math, lap counting)
- **Integration**: Multi-system interaction (checkpoint + race manager)
- **Play**: Manual test scenes for feel-based validation — see
  `docs/standards/manual-testing.md` for how to run it and what to check

See .agents/testing.md for detailed rules.
