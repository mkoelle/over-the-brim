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

---

## Next Recommended Tasks
1. Create `VehicleStats` Resource script (`res://scripts/resources/vehicle_stats.gd`).
2. Create prototype top-hat vehicle scene (`res://scenes/vehicles/tophat_car.tscn`) and controller (`res://scripts/vehicles/vehicle_controller.gd`).
3. Build sandbox test track with collision geometry (`res://scenes/arenas/test_track.tscn`).
4. Write the first real GdUnit4 test suite once #1-3 give something worth testing.
5. Before first real release: provision an Android release keystore and set
   `ANDROID_KEYSTORE_BASE64` / `ANDROID_KEY_ALIAS` / `ANDROID_KEYSTORE_PASSWORD`
   GitHub Secrets (see ADR-007) — until then, release builds are debug-signed.
6. Replace placeholder `icon.svg` with real art once `assets/art/ui/` has one;
   update `config/icon` and `export_presets.cfg`'s icon fields to match.
