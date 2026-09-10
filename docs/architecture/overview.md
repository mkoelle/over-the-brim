# System Architecture Overview

This document defines the high-level system architecture, core managers, data flow, and scaling strategy for **Competitive Racing Arena Party (CRAP)**.

---

## 1. System Topology & Component Map

The game follows a decoupled, composition-based architecture. Major systems own distinct, non-overlapping responsibilities:

```text
┌────────────────────────────────────────────────────────┐
│                   TournamentManager                    │
│      (Brackets, Heats, Points Table, Multi-Table Hub)   │
└───────────────────────────┬────────────────────────────┘
                            │ controls
┌───────────────────────────▼────────────────────────────┐
│                      RaceManager                       │
│    (Countdown, Racing State, Finish, Rules, Timeouts)  │
└──────┬────────────────────┬────────────────────┬───────┘
       │ delegates          │ notifies           │ feeds
┌──────▼──────┐      ┌──────▼──────┐      ┌──────▼──────────────┐
│PlayerManager│      │ Checkpoints │      │  PresenterDirector  │
│(Devices,    │      │  (Laps &    │      │ (Smart Cameras, PiP,│
│ Slots, Auth)│      │ Progression)│      │  Broadcast Overlays)│
└──────┬──────┘      └─────────────┘      └─────────────────────┘
       │ owns (1..4 per peer)
┌──────▼──────────┐
│VehicleController│ (CharacterBody3D, Input Scoping, Physics & Health)
└─────────────────┘
```

### Core Subsystems
1. **`TournamentManager`**: Autoruns match series, point accumulation, Swiss-style heats, and bracket progression. Operates independently of rendering/UI.
2. **`RaceManager`**: Manages active match lifecycle (countdown, racing, paused, finished, sudden death). Authoritative over race time and status.
3. **`PlayerManager`**: Maps physical controllers, keyboard slots, and networked peers to active player entities.
4. **`VehicleController`**: Arcade vehicle handling (`CharacterBody3D`), input translation, visual deformation, damage, and comic balloon-pop respawns.
5. **`CheckpointSystem`**: Validates track traversal order, lap counting, shortcut detection, and track respawn vectors.
6. **`ViewportManager`**: Dynamically partitions the screen into 1, 2, 3, or 4 `SubViewport` windows with independent camera rigs for local couch multiplayer.
7. **`PresenterDirector`**: Dedicated broadcast controller for spectator screens. Directs dynamic cameras, picture-in-picture hazard alerts, and end-of-race highlight recaps.

---

## 2. The Three Foundational Architectural Decisions

To guarantee that early local code never requires expensive rewrites when scaling to networked multiplayer and tournaments, three core rules are locked in:

### Decision 01: Per-Device Input Abstraction
- Vehicle scripts never poll `Input.is_action_pressed()` globally.
- Each vehicle owns an `input_source` (player slot index, gamepad device ID, networked remote state, or AI bot controller).
- **Result**: Local splitscreen, network replication, bot drivers, and phone touch controllers plug into the same car controller without code changes.

### Decision 02: Per-Racer Progress Tracking
- Race progress is strictly modeled as:
  ```gdscript
  var race_progress: Dictionary = {
      racer_id: {
          "lap": int,
          "checkpoint_index": int,
          "distance_to_next": float,
          "rank": int,
          "team_id": int
      }
  }
  ```
- **Result**: Replicating race state over the network is identical whether there is 1 racer, 4 local players, or 16 networked competitors.

### Decision 03: Decouple Network Peer from Vehicle Entities
- A networked peer (a connected machine) is **not** a car.
- A peer owns a list of `0 to 4` cars:
  - `0 cars`: Dedicated Presenter / Spectator client.
  - `1 car`: Standard online player or mobile joiner.
  - `2–4 cars`: A couch splitscreen group joining a networked lobby.
- **Result**: Couch multiplayer groups can join networked matches together seamlessly.

---

## 3. Scaling Architecture: From Couch to 100+ Entrants

The game architecture scales across three tiers without restructuring core code:

| Tier | Scale | Topology | Rendering Model |
|---|---|---|---|
| **Tier 1: Couch Splitscreen** | 1–4 players | 1 machine, local gamepads | 1–4 SubViewports in grid container |
| **Tier 2: Networked Grid** | Up to 16 racers | Up to 4 machines (each 1–4 local) | Local viewport renders only local cars; remote cars replicated via `MultiplayerSynchronizer` |
| **Tier 3: Mega Tournament** | 16–100+ entrants | Multi-table cluster + Coordinator Hub | Independent concurrent 8–16 racer tables reporting results to master `TournamentCoordinator` |

### 16-Racer Network Performance Strategy
- Replicate transforms at **20–30 Hz** instead of 60 Hz to protect bandwidth.
- Use **Hermite/cubic spline interpolation** on clients to maintain silky 60 FPS visuals.
- Quantize positions to 16-bit half-floats and yaw angles to single bytes.

---

## 4. Presenter & Broadcast Architecture

Presenter Mode is built as a zero-racer peer that receives replicated race state and controls a TV/projector broadcast view.

```text
┌─────────────────────────────────────────────────────────────┐
│                      PresenterDirector                      │
├──────────────────────────────┬──────────────────────────────┤
│       Smart Camera Rig       │      Broadcast Overlay       │
│  - Lead Car Tracking         │  - Live Position Ticker      │
│  - Bumper Battle (≤0.5s)     │  - Split Time Deltas         │
│  - Shortcut / Ramp Leap Cam  │  - Mini-map Radar            │
│  - Elimination Danger Cam    │  - Spectator Hazard Banners  │
│  - Auto Crash Replay (PiP)   │  - Clean Feed (No Debug UI)  │
└──────────────────────────────┴──────────────────────────────┘
                               │
               ┌───────────────▼───────────────┐
               │     Rolling Replay Buffer     │
               │   (Past 10 seconds history)   │
               └───────────────┬───────────────┘
                               │ feeds
             ┌─────────────────┼─────────────────┐
             │                 │                 │
      Auto Crash Cam    Highlight Reel     Player Rewind
        (Instant)        (Post-Race)        (Gameplay)
```

### The Shared Rolling Replay Buffer
A circular buffer storing the past 5–10 seconds of vehicle transforms:
1. **Crash Cam**: Instantly triggers a 3-second replay when high-impact collisions occur.
2. **Highlight Reel**: Stitches top lead changes, close finishes, and crash clips into an automated post-race recap.
3. **Player Rewind**: Arcade mechanic allowing players to reverse out of catastrophic mistakes in casual modes.

---

## 5. Dependency Flow & Architecture Rules

```text
UI (Menus, HUD, Overlays)
        ↓ reads
Presentation (Cameras, VFX, Audio, Animations)
        ↓ observes
Systems (RaceManager, TournamentManager, CheckpointSystem)
        ↓ mutates
Data (Player profiles, Track definitions, VehicleStats resources)
```

- **UI Never Owns Gameplay State**: Menus and HUD elements read data; they never modify race rules or scores directly.
- **EventBus Decoupling**: Systems communicate high-level milestones (`race_started`, `lap_completed`, `hazard_triggered`) via the global `EventBus`. Per-frame movement or physics stay strictly localized.
- **Data-Driven Tuning**: Vehicle handling, track parameters, and tournament formats are defined in Godot `.tres` Resource files, enabling hot-reload tuning during testing.
