# Over The Brim

A couch-first multiplayer racing party game where living, wheeled headwear battles through chaotic circuits, spectator-triggered hazards, and high-stakes tournament brackets.

High-octane pack racing where one bad drift—or one vindictive spectator—sends you straight over the brim.


## Design Philosophy

This project follows a few core principles:

- Fun over realism
- Skill over randomness
- Social competition over solitary play
- Emergent gameplay over scripted experiences
- Maintainable systems over quick hacks

The goal is to create a racing game that is easy to pick up, difficult to master, and consistently generates memorable stories between players.

---

## Project Documentation

This repository separates project vision, architecture, standards, and agent guidance into dedicated locations.

### Quick Start Reading Order

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

## Core Game Design

The detailed design documents have been expanded under `docs/design/`:

- **[Race Modes & Tracks](file:///docs/design/race-modes.md)**: Circuit racing, open-city exploration, battle royale elimination, cat & mouse, capture the chicken, ambient traffic, and jumpable ramp trucks.
- **[Spectator System](file:///docs/design/spectator-system.md)**: Active spectator minigames, city & hazard manipulation, team alliances, and dedicated spectator awards.
- **[Vehicle Design & Customization](file:///docs/design/vehicles.md)**: Wheeled top-hat vehicles, expressive animated eyes, hat-on-a-hat stackable accessories, color ribbon customization, and slapstick damage/explosion mechanics.
- **[Event Management & Session Direction](file:///docs/design/event-management.md)**: Role-Based Event Director pattern, delegated session control, mutators/playlists, and Godot 4 multi-window host/presenter twofer.
- **[Project Critique & Risk Analysis](file:///docs/design/critique-and-risks.md)**: Strategic market evaluation, the Hit vs. Miss test rubric, and the 4 fatal traps to avoid.