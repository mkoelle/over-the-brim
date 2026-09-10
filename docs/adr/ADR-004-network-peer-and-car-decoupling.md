# ADR-004: Decouple Network Peer from Vehicle Entities

**Status:** Accepted

**Date:** 2026-09-09

---

### Context

Multiplayer racing games frequently assume a 1:1 relationship between a connected network peer and an active vehicle on track. In couch-first party games, however, multiple players (up to 4) regularly share a single physical console or PC on splitscreen. 

If early single-player or local multiplayer prototypes assume "one peer = one car", transitioning to online or hybrid multiplayer (e.g., 4 local players joining an online 16-car grid) requires a complete rewrite of player management, vehicle spawning, input routing, and viewport handling. Furthermore, spectator and presenter clients need to join without owning any vehicle at all.

---

### Decision

We explicitly decouple the concept of a **Network Peer** (a connected machine) from a **Vehicle Entity**:

1. **A Peer Owns 0 to 4 Vehicles**:
   - `0 cars`: Dedicated Presenter or Spectator client.
   - `1 car`: Standard online player, mobile joiner, or standalone test client.
   - `2 to 4 cars`: A local couch multiplayer group sharing a single machine.
2. **Scoped Input Abstraction**:
   - Vehicles never read global input directly.
   - Every vehicle receives an `input_source` representing its assigned device ID, player slot, or remote network stream.
3. **Progress Keyed by Racer ID**:
   - Checkpoint, lap, and ranking data are stored by unique `racer_id`, not by peer ID or global counters.

---

### Consequences

**Positive:**
- Couch splitscreen players can join networked lobbies together without special-case architectural hacks.
- Dedicated Presenter/Broadcast modes are implemented simply as zero-car peers.
- AI bots and touch-controlled mobile joiners use the identical vehicle controller script without modifications.
- Network bandwidth is reduced because local peers do not replicate vehicle physics to their own split viewports.

**Negative / Tradeoffs:**
- Slightly higher initial setup complexity for local join logic and slot assignment screens.
- Spawner and synchronizer logic must manage an array of vehicles per peer rather than a single entity.

---

### Alternatives Considered

1. **One Peer = One Car Assumption**:
   - Rejected because it prevents couch multiplayer groups from participating in networked races without forcing every player to have their own machine.
2. **Local Players Handled via Virtual Sub-Peers**:
   - Rejected due to unnecessary RPC and transport layer complexity when simple array ownership on the peer object solves the problem cleanly.
