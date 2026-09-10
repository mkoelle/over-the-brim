# ADR-005: Presenter Mode and Active Spectator Architecture

**Status:** Accepted

**Date:** 2026-09-09

---

### Context

Party racing games often suffer from couch downtime: when 5+ players are present or when players are knocked out in elimination modes, bench players must sit and passively watch. Simultaneously, esports events, LAN tournaments, and livestreams require broadcast-quality, multi-camera television coverage without distracting player-specific split-screen HUDs.

---

### Decision

We implement a **Dual-Layer Spectator Architecture**:

1. **Layer 1: Presenter Mode (Broadcaster)**:
   - Operates as a zero-racer peer targeting a secondary monitor, TV, or stream feed.
   - Features **Smart Director Heuristics**: automatically selects camera angles based on lead battles ($\le 0.5$s delta), shortcut launches, elimination cutoffs, and sudden crash impacts.
   - Provides a **Clean Feed** toggle for esports/streaming with live leader tickers and broadcast graphics.
   - Leverages a **Rolling Replay Buffer** (5–10s circular transform history) for auto crash replays, player rewinds, and end-of-race highlight reels.

2. **Layer 2: Active Couch Spectator (Chaos Director)**:
   - Eliminated players and bench spectators use controllers or mobile devices to play lightweight micro-games that generate "Chaos Tokens".
   - Tokens can be spent to trigger map hazards (drawbridges, express trains, steam vents, oil slicks, and ramp trucks) or boost team allies.
   - The Presenter screen shows hazard alerts and picture-in-picture (PiP) trap cams to celebrate spectator influence.

---

### Consequences

**Positive:**
- Zero player downtime: eliminated racers immediately gain meaningful, interactive agency.
- The game can be broadcast on big screens at LAN parties with professional-grade camera direction.
- Replay buffer infrastructure is shared across crash cams, highlight reels, and time-trial ghosts.

**Negative / Tradeoffs:**
- Smart camera director requires heuristic tuning to prevent disorienting camera cuts.
- Memory overhead for maintaining rolling transform histories for up to 16 vehicles (estimated $\approx 2$ MB per minute of history).

---

### Alternatives Considered

1. **Passive Spectator Camera Only**:
   - Rejected because it fails the game's core pillar of couch party entertainment and high player engagement.
2. **Spectator Direct Vehicle Spawning**:
   - Rejected to avoid cluttering the primary race track with extra physical obstacles that break physics budgets.
