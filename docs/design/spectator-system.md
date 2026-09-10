# Spectator System Design

In **Over The Brim**, being eliminated or sitting on the bench does **not** mean putting the controller down. Spectating is an active, competitive role that directly influences race outcomes.

---

## Core Philosophy: Zero Downtime

1. **No Passive Watching**: Eliminated players or tournament bench players always have a controller in hand with meaningful inputs.
2. **Emergent Chaos**: Spectators inject unpredictability that disrupts runaway leaders and creates comedic comeback moments.
3. **Approachable Micro-Play**: Spectator actions are simple to grasp immediately without complex tutorials.

---

## Spectator Mechanics

### 1. Spectator Minigames
While observing the live match, spectators play quick, lightweight micro-challenges on their controller/viewport:
- **Tension Meter / Button Mash**: Charge up an environmental trap by mashing or timing button presses.
- **Rhythm Lock-in**: Hit buttons to a rhythm beat to earn "Chaos Tokens".
- **Targeting Reticle**: Aim an environmental hazard (e.g. water canon, steam vent) onto the track.

### 2. Track & City Manipulation
Spectators spend earned Chaos Tokens to trigger map-wide hazards:
- **Drawbridges**: Raise a bridge to block an oncoming leader or force a ramp jump.
- **Train Gates**: Trigger a crossing signal to dispatch a high-speed train across the track.
- **Traffic Light Hacks**: Turn all lights green or red to create sudden traffic jams.
- **Steam Vents & Manholes**: Launch high-pressure steam that flips or redirects vehicles driving overhead.
- **Oil / Banana Spills**: Deploy slippery surfaces at tight hairpin turns.
- **Ramp Truck Deployment**: Call in a ramp truck to create a spontaneous aerial shortcut.

---

## Team & Versus Spectator Dynamics

In team races or tournament brackets:
- **Allied Spectators**: Spectators can spend tokens to aid teammates (e.g., dropping a slipstream booster, clearing a roadblock, highlighting an optimal shortcut route).
- **Rival Spectators**: Competing spectator factions can actively counter each other (e.g., Team Blue spectators try to close a bridge while Team Red spectators try to hold it open).

---

## Dedicated Spectator Awards

At the end of every race, spectators are celebrated alongside drivers on the victory podium:

| Award | Description |
|---|---|
| **Master Saboteur** | Caused the most spin-outs, crashes, or lead changes via traps. |
| **Guardian Angel** | Boosted or protected their team's racers the most. |
| **Chaos Merchant** | Triggered the highest volume of map events and hazard activations. |
| **Best Spectator (MVP)** | Highest overall spectator score combining minigame accuracy and trap impact. |

Spectator points also count toward overall team rankings in tournament brackets!

---

## Presenter Mode & Broadcast Integration

For spectators watching on a dedicated television, projector, or livestream, **Presenter Mode** operates as a broadcast-grade automated television director (see [ADR-005](file:///docs/adr/ADR-005-presenter-and-active-spectator-architecture.md)):

### Smart Director Camera Heuristics
- **Lead Tracking**: Automatically follows the current race leader.
- **Bumper Battle Cam**: Cuts to close pack racing when 2–3 cars are within $\le 0.5$s delta.
- **Shortcut & Ramp Cam**: Frames vehicles launching off ramp trucks or diving into secret alleyways.
- **Elimination Danger Cam**: In Battle Royale mode, targets the car in last place during the final countdown seconds.
- **Auto Crash Cam**: Triggers an automatic 3-second cinematic replay when severe collisions occur.

### Broadcast Stage & Trap Feeds
- **Hazard Activation Banners**: Prominently displays which spectator triggered an event (*"Player 3 triggered TRAIN CROSSING!"*).
- **Picture-in-Picture (PiP) Trap Cam**: Shows a mini-window of the hazard deploying as the lead pack approaches.
- **Clean Feed Toggle**: Hides all debug/editor interfaces, showing only TV-style position tickers, lap times, and player avatars.

