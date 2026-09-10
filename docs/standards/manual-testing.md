# Manual Testing

Expands the "Play" test category in `docs/standards/testing-standards.md` —
GdUnit4 confirms the code doesn't crash or NaN; it can't tell you whether
driving is actually fun (Guardrail 1/3, `docs/design/game-pillars.md`).
That's what this is for.

## Running it

Open the project in the Godot editor and press **F5** (or the Play
button) — `scenes/main.tscn` is the configured main scene, so it spawns
the car on the test track directly.

From a terminal, without opening the editor:

```
godot --path . scenes/main.tscn
```

(headless mode won't render a window and can't be used for feel-testing —
see the CI/verification commands in `docs/standards/testing-standards.md`
for headless-only checks.)

## Current controls

| Action | Keyboard | Gamepad |
| --- | --- | --- |
| Throttle | W | Right trigger |
| Brake / reverse | S | Left trigger |
| Steer left | A | Left stick |
| Steer right | D | Left stick |
| Drift | Space | Right shoulder/bumper |

Source of truth is `project.godot`'s `[input]` section — if this table
and that file disagree, the file is right and this needs updating.

## What to check (Iteration 01: Drivable Prototype)

Tied to STATE.md's Definition of Done — this is a pass/fail against
Guardrail 3 (the "1-Car Fun" Rule), not a bug hunt:

- **Acceleration** — does throttle feel responsive, or sluggish/floaty?
- **Braking** — does it feel like it actually sheds speed, not just
  "less throttle"?
- **Steering** — does turn-in feel controllable at speed, and not
  overly stiff/twitchy at low speed?
- **Reverse steering** — does steering while backing up curve the path
  the direction you'd expect (this was inverted and fixed once already —
  confirm it still feels right)?
- **Drift** — does holding drift produce a readable slide, and does
  releasing it feel controllable rather than snapping back violently?
- **Camera** — does the chase camera track smoothly through the corner
  and up the ramp without clipping into geometry or lagging so far
  behind the car goes off-screen?
- **Collision** — drive into the boundary walls, the mid-field obstacle,
  and off the ramp. Confirm nothing clips through, nothing gets stuck,
  nothing launches unexpectedly.
- **Console** — check the editor's Output panel for any errors or
  warnings during play.

## Filing what you find

Use `docs/templates/bug-report.md` for anything concrete (crash,
clipping, stuck state). For pure feel/tuning notes ("acceleration feels
too slow"), a note in STATE.md's Recent Progress or a direct tuning pass
on the relevant `VehicleStats`/`ChaseCamera` export is enough — these
aren't "bugs," they're calibration.

## Debug mode

Does not exist yet. STATE.md's Iteration 01 task list (item 9, optional/
P2) specs a `GameConfig.debug_mode` flag gating an on-screen speed/gear
HUD, off by default — not yet implemented. Until then, the editor's
Remote Inspector (while the game is running) or a temporary `print()` in
`vehicle_controller.gd` are the only ways to see live values.
