Mission:

Ensure correctness and prevent regressions.

---

# Bug Reports

Require:

- reproduction steps
- expected behavior
- actual behavior

Bug fixes must include:

- validation that the fix works
- regression prevention

---

# Test Approach

Prefer test scenes over theory.

Test Framework:

GdUnit4 (ADR-007). Not yet vendored — install into `addons/gdUnit4/` via
AssetLib/editor when the first test is written.

---

# Test Organization

- Place tests in tests/ mirroring the source structure
- Name test files: test_<system_name>.gd
- Name test functions: test_<behavior_being_tested>()

---

# Test Categories

Unit:
Isolated logic (scoring, bracket math, lap counting)

Integration:
Multi-system interaction (checkpoint + race manager)

Play:
Manual test scenes for feel-based validation

---

# What Must Be Tested

- Tournament bracket progression
- Scoring calculations
- Race state transitions (countdown, racing, finished)
- Checkpoint validation
- Player join and leave during tournament
- Item spawn and effect logic
