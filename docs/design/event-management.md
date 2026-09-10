# Event Management & Session Direction

This document details the session hosting, match configuration, role delegation, and multi-monitor display architecture for **Over The Brim**.

---

## 1. Core Philosophy: Eliminating "Host Fatigue"

In couch and LAN party games, the host often becomes an unpaid tournament administrator: trapped in configuration menus, re-seeding brackets, and adjusting settings while everyone else plays.

**Over The Brim solves this with the Role-Based Event Director pattern**:
- The machine running the server is decoupled from the person running the event.
- Event management can live on the host, be delegated to a spectator/presenter client, or run across multiple local screens simultaneously.

---

## 2. The Hybrid Pattern: "Role-Based Event Director"

We explicitly separate **Network Server Authority** from **Session Director Authority**:

```text
┌────────────────────────────────────────────────────────┐
│                   GameConfig / Series                  │
│       (Authoritative state lives on Server Peer 1)     │
└───────────────────────────▲────────────────────────────┘
                            │ Authorized Session Updates
        ┌───────────────────┴───────────────────┐
        │                                       │
┌───────┴────────┐                     ┌────────┴──────────────┐
│   Host Machine │                     │   Presenter Client    │
│ (Network Server│   delegate_token    │ (Secondary PC / Tablet│
│  peer_id == 1) ├────────────────────►│ holds director_token) │
└───────┬────────┘                     └───────────────────────┘
        │
        │ Local Dual-Window (DisplayServer.window_create)
┌───────▼──────────────┐
│ Window 2: Pop-out    │
│ Broadcast / Operator │
└──────────────────────┘
```

### Authority & Roles
- **Server Host (`peer_id == 1`)**: Authoritative over physics, network replication, packet transport, and player connection lifecycle.
- **Director Token (`director_token`)**: A transferable permission granting authority over:
  - Match start/pause/abort.
  - Track selection and series playlists.
  - Feature toggles (traffic on/off, spectator hazards enabled/disabled, item tiers).
  - Bracket adjustments (seeding, byes, manual heat overrides).

### Delegation & Fallback Lifecycle
1. **Default State**: Host holds `director_token`. Menus appear on the host screen between races.
2. **Delegation**: The host can click *"Delegate Director to Presenter"* (or assign to a verified referee/mobile client).
   - Once delegated, the host's screen simplifies into a pure player HUD with an unobtrusive "Ready" status.
   - The delegated client gains the full **Event Master Console**.
3. **Automatic Fallback**: If the delegated client disconnects, packet timeouts occur, or the host presses an override hotkey (`F12`), the `director_token` immediately snaps back to the Host server without stalling the session.

---

## 3. The Multi-Monitor "Host/Presenter Twofer"

For hosts running on hardware with multiple displays (e.g. desktop with dual monitors, or a gaming laptop connected to a living room TV/projector via HDMI), Godot 4's multi-window architecture (`DisplayServer.window_create()` or dedicated `Window` nodes) allows the host to run **both roles on a single machine**.

### Supported Multi-Monitor Profiles

| Profile | Primary Display (Screen 1) | Secondary Display (Screen 2) | Best For |
|---|---|---|---|
| **A. Standard Single Screen** | 1–4 Player Splitscreen + In-between Menus | *(None)* | Casual couch play on a single TV. |
| **B. Broadcast Twofer** | 1–4 Player Splitscreen (Local Racers) | Clean Presenter Feed (TV / Projector / Stream) | LAN parties where the room watches the big screen while players race on a monitor. |
| **C. Operator Twofer** | Clean Presenter Feed or Main Race Screen | Private Operator Dashboard (Laptop screen) | A tournament caster or host managing brackets privately without exposing menus to the room. |
| **D. Networked Director** | Host Game View | Handled by remote client (Tablet / Laptop / Phone) | Dedicated referee walking around venue with a tablet. |

### Technical Multi-Window Implementation
- The secondary window is instantiated via a sub-`Window` or `DisplayServer.window_create()`:
  - Runs in the same process memory space (zero network lag, zero packet bandwidth overhead).
  - Renders an isolated `SubViewport` running the `PresenterDirector` camera rig or `OperatorPanel` UI.
  - Can be fullscreened onto Display Index 1 (`DisplayServer.window_set_current_screen(1, window_id)`).

---

## 4. Session Configuration & Feature Toggles

The Event Director console exposes modular match toggles grouped into clear categories:

### A. Track & Playlist Controls
- Track list / playlist sequence (Random, Linear, Voted, Elimination order).
- Lap counts (or time limit for Open City / Battle Royale modes).

### B. Chaos & Hazard Mutators
- **Spectator Hazard Level**: Disabled | Standard | Chaos Overload (fast token gain, zero cooldowns).
- **Ambient City Traffic**: Off | Light | Rush Hour.
- **Ramp Trucks**: Off | Static | Mobile Patrol.
- **Slipstream Strength**: Weak | Standard | High Slingshot.

### C. Vehicle & Item Toggles
- **Item Distribution**: Standard | Defensive Only | High Impact Only | No Items (Pure Driving).
- **Vehicle Damage**: Cosmetic Only | Standard (Crumple + Explode) | One-Hit Explosion.
- **Player Catch-up**: None | Mild Rubber-banding | Party Assistance.
