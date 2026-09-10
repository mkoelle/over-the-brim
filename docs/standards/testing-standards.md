# Testing Standards

## Bug Reports

Require:
- reproduction steps
- expected behavior
- actual behavior

## Test Framework

To be decided via ADR. Candidates: GdUnit4, GUT.

## Test Categories

- **Unit**: Isolated logic (scoring, bracket math, lap counting)
- **Integration**: Multi-system interaction (checkpoint + race manager)
- **Play**: Manual test scenes for feel-based validation

See .agents/testing.md for detailed rules.
