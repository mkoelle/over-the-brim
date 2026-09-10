# Competitive Racing Arena Party (CRAP)

A couch-first multiplayer racing party game focused on chaotic competition, massive tournaments, open track design, and memorable social moments.

Players race through circuits, shortcuts, elimination events, and tournament brackets where skill, risk-taking, and player interaction matter just as much as raw speed.

## Design Philosophy

This project follows a few core principles:

- Fun over realism
- Skill over randomness
- Social competition over solitary play
- Emergent gameplay over scripted experiences
- Maintainable systems over quick hacks

The goal is to create a racing game that is easy to pick up, difficult to master, and consistently generates memorable stories between players.

---

# Project Documentation

This repository separates project vision, architecture, standards, and agent guidance into dedicated locations.

## Quick Start Reading Order

For humans:

1. `README.md`
2. `CONTEXT.md`
3. `docs/design/game-pillars.md`
4. `docs/architecture/overview.md`

For coding agents:

1. `AGENTS.md`
2. `CONTEXT.md`
3. `STATE.md`
4. Relevant documentation under `docs/`

---

# Repository Layout

```text
.
├── .agents
│   ├── gameplay.md
│   ├── networking.md
│   ├── performance.md
│   ├── physics.md
│   ├── testing.md
│   └── ui.md
│
├── AGENTS.md
├── CONTEXT.md
├── STATE.md
│
├── docs
│   ├── adr
│   │   └── DECISIONS.md
│   │
│   ├── architecture
│   │   └── overview.md
│   │
│   ├── design
│   │   └── game-pillars.md
│   │
│   ├── standards
│   │   ├── gdscript-style-guide.md
│   │   ├── performance-budgets.md
│   │   ├── testing-standards.md
│   │   ├── code-review-checklist.md
│   │   └── asset-organization.md
│   │
│   └── templates
│       ├── adr-template.md
│       ├── feature-proposal.md
│       ├── bug-report.md
│       └── task-template.md
│
└── README.md
```

---

# Root Files

## AGENTS.md

Primary instruction file for coding agents.

Defines:

- repository rules
- coding standards
- architecture constraints
- implementation priorities
- workflow expectations

Agents should always start here.

---

## CONTEXT.md

High-level project vision.

Defines:

- project goals
- target audience
- gameplay pillars
- core loops
- major design constraints

This file explains *why* decisions are made.

---

## STATE.md

Current development status.

Tracks:

- active milestone
- current priorities
- known risks
- recent progress
- next recommended tasks

This file changes frequently.

---

# Documentation

## docs/architecture

Technical system design.

Examples:

- race architecture
- tournament systems
- networking strategy
- save systems
- UI architecture
- scene organization

Focuses on *how the game is built*.

---

## docs/design

Gameplay and product design.

Examples:

- game pillars
- race modes
- progression systems
- track philosophy
- vehicle design
- player experience goals

Focuses on *how the game should feel*.

---

## docs/adr

Architectural Decision Records.

Stores important decisions and why they were made.

Examples:

- Godot version selection
- networking approaches
- save formats
- tournament architecture

Avoids re-litigating solved problems.

---

## docs/standards

Project-wide development standards.

Examples:

- GDScript style guides
- naming conventions
- performance expectations
- testing requirements
- asset organization rules

These documents define the project's engineering standards.

---

## docs/templates

Reusable document templates.

Examples:

- feature proposals
- ADRs
- bug reports
- implementation plans
- task definitions

Use templates to keep project documentation consistent.

---

# Agent Specialists

The `.agents/` directory contains focused instruction sets for domain-specific work.

## gameplay.md

Gameplay design specialist.

Focus:

- game feel
- risk/reward
- player interaction
- competitive balance

---

## networking.md

Networking specialist.

Focus:

- synchronization
- authority
- multiplayer safety
- scalability

---

## performance.md

Performance specialist.

Focus:

- frame rate
- split-screen optimization
- memory usage
- profiling

---

## physics.md

Vehicle handling specialist.

Focus:

- responsiveness
- control
- predictability
- driving feel

---

## testing.md

Testing specialist.

Focus:

- validation
- reproducibility
- regression prevention
- verification workflows

---

## ui.md

UI and UX specialist.

Focus:

- readability
- information hierarchy
- player feedback
- accessibility

---

# Long-Term Goals

The architecture should comfortably support:

- 2-4 player couch multiplayer
- local tournaments
- large tournament brackets
- custom events
- multiple race modes
- future online support
- community-created content

Every major system should be designed with those capabilities in mind.

---

# Core Rule

When making decisions:

```text
Fun
    ↓
Clarity
    ↓
Maintainability
    ↓
Performance
    ↓
Feature Completeness
```

If a solution violates the game's core pillars, it is the wrong solution regardless of technical quality.