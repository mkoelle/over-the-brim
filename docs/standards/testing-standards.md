# Testing Standards

## Bug Reports

Require:
- reproduction steps
- expected behavior
- actual behavior

## Test Framework

GdUnit4 (ADR-007). Install via AssetLib/editor into `addons/gdUnit4/`.
Run headless: `godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd --add tests -rd -c`.
CI (`.github/workflows/ci.yml`) runs this automatically once the addon is present.

## Test Categories

- **Unit**: Isolated logic (scoring, bracket math, lap counting)
- **Integration**: Multi-system interaction (checkpoint + race manager)
- **Play**: Manual test scenes for feel-based validation

See .agents/testing.md for detailed rules.
