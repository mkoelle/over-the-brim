# AGENTS.md

Purpose:
Guide all coding agents working in this repository.

---

# Startup Procedure

Read files in this order:

1. CONTEXT.md
2. STATE.md
3. docs/architecture/overview.md
4. docs/design/game-pillars.md
5. Relevant documents for current task

Do not scan entire repository unless necessary.

---

# Project Summary

Engine:
Godot 4.x

Language:
GDScript only

Genre:
Tournament-focused multiplayer party racer

Core Principles:

- Couch multiplayer first
- Competitive but approachable
- Fast iteration
- Emergent player stories
- Chaos with strategic depth

---

# Required Behaviors

Before implementing:

- understand goal
- inspect existing patterns
- identify impacted systems

Before modifying architecture:

- check ADR documents
- verify decision consistency

Before creating new systems:

- check for existing implementations
- avoid duplication

---

# Decision Hierarchy

When tradeoffs occur:

1. Fun
2. Clarity
3. Maintainability
4. Performance
5. Feature completeness

---

# Coding Rules

Use static typing.

Prefer:

```gdscript
var speed: float = 0.0
```

Avoid:

```gdscript
var speed
```

Use:

```gdscript
class_name RaceManager
```

for reusable systems.

Use:

```gdscript
signal race_finished
```

for communication.

Avoid direct dependencies when signals are sufficient.

---

# Scene Rules

One scene should have one responsibility.

Good:

Vehicle
HUD
RaceManager
Checkpoint

Bad:

GameEverythingManager

Split complex scenes.

Favor composition.

Avoid deep inheritance.

Maximum inheritance depth:

3

---

# Architecture Rules

Dependencies flow:

UI
↓
Presentation
↓
Systems
↓
Data

Never reverse dependency flow.

UI cannot own gameplay state.

Gameplay cannot depend on menu systems.

---

# Multiplayer Rules

Assume future online support.

Avoid:

- single-player assumptions
- global player references
- player one hardcoding

Support:

- split screen
- local tournament play
- future networking expansion

Player ownership must always be explicit.

---

# Tournament Rules

Tournament progression is core identity.

Tournament systems must:

- be deterministic
- be independent of UI
- support elimination formats
- support points formats
- support custom formats

Bracket logic must never live inside UI.

---

# Performance Rules

Avoid:

- allocations in _process()
- repeated get_node()
- loading resources during gameplay

Use:

- pooling
- cached references
- preloading

Optimization targets:

60 FPS minimum
4-player split screen minimum

---

# File Creation Rules

Before creating:

VehicleSystem.gd

check if:

VehicleController.gd

already solves problem.

Prefer extending existing systems.

Avoid parallel implementations.

---

# Documentation Rules

Architectural decisions:

docs/adr/

Coding standards:

docs/standards/

Design decisions:

docs/design/

Do not place large documentation in AGENTS.md.

---

# Boundaries

Never modify:

- .godot/
- .import/
- *.uid files directly
- addons/ vendor code without approval

Never commit:

- export_presets.cfg
- .DS_Store

---

# Development Commands

Run game:

```bash
godot --path . --scene res://scenes/main.tscn
```

Run tests:

Defined after test framework ADR.

---

# Naming Conventions

Files: snake_case.gd

Classes: PascalCase

Variables: snake_case

Constants: UPPER_SNAKE_CASE

Signals: past_tense_snake_case (race_finished, lap_completed)

Nodes: PascalCase matching purpose (PlayerVehicle, RaceHUD)

Scenes: snake_case.tscn matching primary script

---

# Autoload Policy

Use Autoloads for:

- EventBus (global signal bus)
- GameConfig (settings and constants)

Do not use Autoloads for:

- per-race state
- player-specific data
- UI management

Minimize Autoload count.

---

# Verification

After modifying scripts:

- confirm no parse errors
- verify scene references are intact
- run affected test scenes

After modifying scenes:

- verify node paths are valid
- check signal connections
- test with 2+ players when relevant

---

# Output Style

For technical responses:

Problem
Cause
Fix
Risks
Files

Keep explanations concise.

Prioritize implementation guidance.
