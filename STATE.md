# Development State

## Active Milestone
**Phase A: Foundation — Iteration 01: Drivable Prototype**

---

## Current Priorities
1. **Core Vehicle Feel**: Implement `CharacterBody3D` vehicle controller with arcade acceleration, steering bite, and responsive drift dynamics.
2. **Data-Driven Tuning**: Expose vehicle physics parameters via a `VehicleStats.tres` custom Resource for rapid iteration.
3. **Test Track Sandbox**: Construct an initial prototype circuit in `scenes/arenas/test_track.tscn` with corners, ramps, and barriers to evaluate handling.

---

## Known Risks & Traps
- **Over-Engineering Before Fun**: Guarding against writing tournament coordinators or complex netcode before proving that 1 car driving on 1 track is inherently fun.
- **Competitive vs. Party Paradox**: Enforcing the *Telegraphed Chaos Rule* so spectator hazards remain avoidable with high skill.
- **Touchscreen Steering Trap**: Confining mobile/touch input to spectator sabotage and voting, leaving driving strictly to physical gamepads/keyboards.

---

## Recent Progress
- Adopted official project title: **Over The Brim** (replacing provisional title).
- Established full vehicle archetype roster (Stovepipe Speedster, Bowler Bruiser, Fez Drifter, Sombrero Brawler, Flat Cap Scrapper).
- Initialized Godot 4.7 project, display settings, and 3D collision layer mapping.
- Scaffolded repository directory structure matching asset standards.
- Codified foundational architectural decisions (ADR-001 through ADR-006).
- Documented core game design for Race Modes, Active Spectator System, Vehicle Customization, and Event Management.
- Established design guardrails and strategic risk analysis.
- Added build/test/release foundation (ADR-007): placeholder app icon,
  `export_presets.cfg` for Windows/Linux/macOS/Android, GitHub Actions CI
  (`ci.yml`) and tag-triggered release pipeline (`release.yml`).
- Vendored GdUnit4 (v6.2.0) into `addons/gdUnit4/`, enabled in
  `project.godot`, verified locally against Godot 4.7.2 (correct pass/fail
  exit codes; `ci.yml` updated with the working CLI invocation + a timeout
  guard for the zero-test-suite edge case).
- Closed remaining release-infra gaps: `application/config/version` as the
  version source of truth (`docs/standards/versioning.md`), macOS `.icns` +
  Android adaptive launcher icons (placeholder art, generated from
  `icon.svg`), `CHANGELOG.md`, and a documented branching/PR policy
  (`docs/standards/branching.md`).

---

## Definition of Done — Iteration 01 (Drivable Prototype)

Guardrail 3, the **"1-Car Fun" Rule**, in verifiable form: one hat-car,
spawned on one test track, driven from a gamepad or keyboard, feels
responsive — accelerate, brake, steer, drift — with no other system
(menus, AI, networking, tournaments) in the loop. Ship nothing past this
list until that's true and feels good.

## Next Recommended Tasks

Sized per `docs/standards/task-sizing.md` (1-4h, 1-3 files, one
verification step each). Do them in order — each depends on the ones
before it unless marked parallel.

1. **Input Map** — define real input actions in `project.godot`
   (`throttle`, `brake`, `steer_left`, `steer_right`, `drift`), each bound
   to keyboard *and* gamepad. No code yet.
   *Verify*: Project Settings → Input Map shows all five, each fires in
   the Input Map's live test view.

2. **Per-device input source** (`scripts/vehicles/input_source.gd`) —
   small class wrapping a device index, polling the actions from #1 with
   Godot's per-device input APIs, exposing a normalized
   `{throttle, steer, drift}` read. This is Architecture Decision 01
   (`docs/architecture/overview.md`) — vehicles must never poll `Input`
   globally, so this has to exist before the controller does.
   *Verify*: a temp script prints the struct while a controller is held;
   values change only for that device's input.
   *Depends on*: 1.

3. **`VehicleStats` Resource** (`scripts/resources/vehicle_stats.gd` +
   one instance, `resources/vehicles/stovepipe_speedster.tres`) — exported
   `max_speed`, `acceleration`, `steering_rate`, `drift_grip`, `mass`.
   Parallel with 1-2.
   *Verify*: `.tres` opens in the Inspector with editable exported fields.

4. **Vehicle controller + placeholder scene**
   (`scripts/vehicles/vehicle_controller.gd`,
   `scenes/vehicles/tophat_car.tscn`) — `CharacterBody3D`, primitive
   capsule/box mesh (real hat art comes later), reads #2 + #3 to move:
   accelerate/brake along facing, steer, basic drift slip.
   *Verify*: instanced alone in an empty test scene with a flat floor,
   WASD/gamepad moves and turns it.
   *Depends on*: 2, 3.

5. **Test track sandbox** (`scenes/arenas/test_track.tscn`) — flat ground
   plane, a few corners, walls, one ramp; `StaticBody3D` collision only,
   no art pass. Parallel with 1-4.
   *Verify*: scene opens standalone, floor and walls have collision
   (drop a `RigidBody3D` on it in-editor and confirm it rests on top).

6. **Chase camera** (`scripts/camera/chase_camera.gd`) — single
   `Camera3D` trailing the vehicle's transform. Not the full
   `PresenterDirector`/`ViewportManager` from the architecture doc —
   that's multi-viewport/broadcast machinery with no reason to exist
   before one car is fun to drive.
   *Verify*: attached to the car from #4 in a scratch scene, camera
   follows smoothly through turns without clipping through geometry.
   *Depends on*: 4.

7. **Wire up `main.tscn`** — replace the placeholder title-label content
   with: instance `test_track.tscn`, instance `tophat_car.tscn` at a spawn
   point, attach the chase camera. `main.gd` emits one `EventBus` signal
   (e.g. `race_started`) once everything is ready — no listeners need to
   exist yet.
   *Verify*: run the project (F5) — car spawns on the track, is
   drivable, camera follows. This is the milestone's actual finish line.
   *Depends on*: 3, 4, 5, 6.

8. **Real GdUnit4 test** (`tests/unit/test_vehicle_controller.gd`) —
   replace reliance on the boot-only smoke test: load `vehicle_stats.tres`,
   drive the controller via `scene_runner().simulate_frames()` with a
   fixed throttle input, assert it moved and didn't NaN out.
   *Verify*: `godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a
   tests --ignoreHeadlessMode -c` passes.
   *Depends on*: 3, 4.

9. **Debug HUD toggle** (P2, optional) — on-screen speed/gear readout
   gated behind a `GameConfig.debug_mode` flag, off by default. Keeps
   debug tools separated from the player experience per the maturity
   checklist; skip if #1-8 already feel done without it.
   *Depends on*: 4, 7.

### Explicitly out of scope for this milestone

Per the *Over-Engineering Before Fun* risk below and Guardrail 3: no
`TournamentManager`, `RaceManager` state machine, `PlayerManager`,
networking/`MultiplayerSynchronizer`, splitscreen `SubViewport` grid,
spectator/hazard systems, or menus. Add these only once one car on one
track is confirmed fun.

### Deferred, non-blocking (do before a *real* release, not before this milestone)

- Provision an Android release keystore and set `ANDROID_KEYSTORE_BASE64` /
  `ANDROID_KEY_ALIAS` / `ANDROID_KEYSTORE_PASSWORD` GitHub Secrets (see
  ADR-007) — release builds stay debug-signed until then.
- Replace placeholder `icon.svg`/derived `.ico`/`.icns`/Android icons with
  real art once `assets/art/ui/` has one; update `config/icon` and every
  `export_presets.cfg` icon field to match.
