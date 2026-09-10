# ADR-006: Role-Based Event Direction and Multi-Window Host Architecture

**Status:** Accepted

**Date:** 2026-09-09

---

### Context

Organizing couch and LAN party tournaments often forces the network host into an exhausting administrative role: constantly manipulating match settings, track rotations, and bracket rosters from the main player screen. Furthermore, when organizing LAN events or livestreams, the host machine may be connected to multiple monitors (e.g. a desktop monitor plus an external TV/projector). 

We need a system where:
1. The host can delegate match configuration to a dedicated presenter, referee, or mobile client.
2. If the host has multiple monitors, a single PC can simultaneously drive the active player split-screen *and* output a dedicated broadcast or operator window without requiring a second computer.

---

### Decision

1. **Role-Based Event Director (`director_token`)**:
   - Decouple **Network Server Authority** (`peer_id == 1`) from **Session Management Authority**.
   - Server Peer 1 remains the authoritative network host, but match management permissions are held by whichever peer possesses the `director_token`.
   - The token can be retained by the Host or delegated to any verified client (Presenter PC, tablet, or mobile phone).
   - If the delegated peer disconnects, the token automatically falls back to Server Peer 1.

2. **Godot 4 Multi-Window "Host/Presenter Twofer"**:
   - On desktop platforms supporting multi-windowing (`DisplayServer.has_feature(DisplayServer.FEATURE_SUBWINDOWS)`), the host can spawn a secondary OS window using `DisplayServer.window_create()` or sub-`Window` nodes.
   - Screen 1 displays the local 1–4 player split-screen racing viewport.
   - Screen 2 displays either:
     - The **Clean Broadcast Presenter Feed** (for a living room TV, projector, or OBS stream capture).
     - The **Private Operator Console** (for managing brackets and playlists out of view of the players).
   - Both windows run in the same engine process, sharing local state with zero network bandwidth overhead.

---

### Consequences

**Positive:**
- Complete flexibility: single TV couch play, multi-monitor single-PC party setups, and dedicated multi-machine LAN tournaments are all supported by the same codebase.
- Streamers and LAN hosts with dual monitors can run high-production broadcasts without a secondary streaming PC.
- Racer screens remain 100% focused on gameplay and victory podiums without administrative interruptions.

**Negative / Tradeoffs:**
- Multi-window functionality is desktop-only (macOS, Windows, Linux) and must be gracefully disabled or hidden on mobile or console builds.
- Session configuration changes must be synchronized to all connected peers via reliable RPCs rather than local direct variable writes.

---

### Alternatives Considered

1. **Event Management Hardcoded into Host Viewport Only**:
   - Rejected because it forces player screens to be interrupted by administrative UI and prevents remote referee delegation.
2. **Requiring a Second Physical PC for Presenter Mode**:
   - Rejected because users with dual-monitor PCs or laptop-to-TV setups can achieve the exact same result on one machine using Godot 4's multi-window capabilities.
