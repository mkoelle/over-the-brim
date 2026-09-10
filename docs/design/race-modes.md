# Race Modes Design

This document details the planned game modes, track events, and environmental mechanics for **Over The Brim**.

---

## Design Principles for Modes

Every race mode must:
- Support **2–4 local players** minimum.
- Emphasize **risk vs. reward** shortcuts and player interaction.
- Provide **comeback potential** without unfair, heavy-handed rubber-banding.
- Seamlessly transition eliminated players into the [Spectator System](file:///docs/design/spectator-system.md).

---

## Core Game Modes

### 1. Circuit Race
- **Format**: Traditional lap-based racing with fixed checkpoints and finish lines.
- **Core Loop**: Lap times, mastering corners, discovering alternative shortcut routes.
- **Party Twist**: Dynamic hazards, player collisions, and shifting route gates between laps.

### 2. Open City Race
- **Format**: Point-A to Point-B or multi-district checkpoint race in an open urban environment.
- **Core Loop**: No single fixed route; players must navigate city streets, alleys, rooftops, and parks.
- **Dynamic Elements**: Moving traffic, destructible barriers, and spectator-triggered hazards.

### 3. Battle Royale / Elimination
- **Format**: Last-vehicle-standing elimination.
- **Variants**:
  - **Timed Cutoff**: The last-place racer every 30 seconds is eliminated until one remains.
  - **Shrinking Hazard Arena**: City zones lock down or fill with hazards, forcing players closer together.
- **Downtime Elimination**: Eliminated players immediately join as active spectators with sabotage abilities.

### 4. Open City Battle Royale
- **Format**: Wide-area vehicular survival across the entire city map.
- **Core Loop**: Combines open route navigation with vehicle combat, hazard evasion, and power-up hunting.

### 5. Cat & Mouse
- **Format**: Asymmetrical team mode.
- **Rules**:
  - Each team has one "Mouse" (nimble, fast, fragile) and one or more "Cats" (heavy, defensive brawlers).
  - The goal is for your team's Mouse to finish first while your Cats hunt and disrupt the opposing Mouse.

### 6. Capture the Chicken
- **Format**: Vehicular keep-away / king of the hill.
- **Rules**:
  - A rubber chicken sits on the field; running into it attaches it to your roof.
  - Holding the chicken accumulates points or drains a victory countdown.
  - Ramming the carrier knocks the chicken free for others to steal.

### 7. Stunt Tracks
- **Format**: High-flying score and trick arenas.
- **Features**: Massive vertical loops, death-defying jumps, half-pipes, and trick multipliers.

---

## Dynamic Environmental Features

### Ambient City Traffic
- AI vehicles (sedans, buses, delivery vans) driving along predefined lane paths.
- Can be used as mobile cover, pushed into opponents, or drafted behind for slipstream speed.

### Ramp Trucks
- Flatbed tow trucks with angled ramps driving along roads or parked at strategic corners.
- Allows racers to launch over traffic, onto elevated highways, or onto building roofs for major shortcuts.

### City Infrastructure Manipulation
- Drawbridges that can be raised or lowered.
- Railroad crossings with incoming express trains.
- Construction cranes swinging girders across intersections.
- *Can be triggered by track timers or by spectators.*
