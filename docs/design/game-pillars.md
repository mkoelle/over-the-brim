# Game Pillars & Design Guardrails

This document defines the core pillars and non-negotiable design guardrails for **Competitive Racing Arena Party (CRAP)**.

---

## Core Pillars

### 1. Fun > Realism
- Vehicles should handle with arcade snap and responsiveness, not rigid simulation.
- Players should laugh frequently; collisions, spin-outs, and explosions are slapstick comedy, not punishment.

### 2. Shortcuts Should Be Discoverable
- Track design prioritizes high-risk, high-reward alternative routes (alleys, ramp trucks, rooftop hops).
- Shortcuts are readable and reward courage and map knowledge.

### 3. Winning Must Require Skill
- A superior driver will consistently win clean races.
- Power-ups and spectator traps disrupt momentum, but cannot replace driving competence.

### 4. Chaos Creates Opportunity, Not Randomness
- Chaos shakes up the running order to prevent runaway leaders.
- Chaos must never feel like an unavoidable coin flip.

### 5. Races Remain Competitive Until the Final Moments
- Pack racing is kept tight through slipstreaming, drafting cones, and rubber-banding assistance.
- No player should feel out of contention with half a lap remaining.

### 6. Every Mode Must Support:
- Couch multiplayer (1–4 local players).
- Tournament play (heats, points, and brackets).
- Spectator excitement (active room participation).

---

## Design Guardrails & Non-Negotiables

These guardrails protect the game from the "Competitive vs. Party" paradox and keep development grounded:

### Guardrail 1: The Telegraphed Chaos Rule
- **Every trap, hazard, and spectator action must have a clear audio/visual telegraph.**
- A drawbridge does not slam instantly; it flashes warning lights and rings a bell.
- A train crossing sounds a loud horn 2.5 seconds before passing.
- **Test**: *Can an elite driver with god-tier reflexes react to the telegraph and avoid or jump the hazard?* If yes, it's great game design. If no, it's cheap randomness.

### Guardrail 2: Input Boundary Rule
- **Gamepads / Keyboards are for driving.** Precision arcade vehicle control requires tactile analog sticks or keys.
- **Mobile phones / Touchscreens are for spectator chaos, betting, and voting.** Never force players into virtual touchscreen steering wheels.

### Guardrail 3: The "1-Car Fun" Rule
- Never build complex tournament coordinators, netcode lobbies, or secondary systems for a game whose core driving isn't fun yet.
- If driving a single top-hat car around a single flat corner isn't instantly responsive and satisfying, stop and fix handling before touching anything else.

### Guardrail 4: Zero Couch Downtime
- Being knocked out or sitting on the bench does not mean putting down the controller.
- Eliminated players immediately become active chaos spectators with real agency to impact the race.