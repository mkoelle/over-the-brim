class_name VehicleStats
extends Resource
## Data-driven tuning knobs for one vehicle archetype.
##
## Per docs/design/vehicles.md's Technical Implementation section, physics
## tuning is exposed as exported variables on a Resource so designers can
## live-tune acceleration, grip, drift slip, and top speed without touching
## `vehicle_controller.gd` or recompiling scripts. One `.tres` instance per
## archetype (e.g. `resources/vehicles/stovepipe_speedster.tres`).
##
## Defaults on this script are deliberately snappy arcade values, not
## simulation-accurate ones — "Fun > Realism" is pillar #1
## (docs/design/game-pillars.md).

## Top speed the vehicle can reach under full throttle, in meters/second.
@export var max_speed: float = 25.0

## Forward speed gained per second under full throttle, in meters/second^2.
@export var acceleration: float = 15.0

## Forward speed lost per second under full brake, in meters/second^2.
@export var braking_force: float = 25.0

## Turn rate at full steering input, in radians/second.
@export var steering_rate: float = 2.5

## Fraction of lateral grip retained while drifting, 0..1 — 1.0 means no
## slide at all, lower values mean more slide/slip through the drift.
@export_range(0.0, 1.0) var drift_grip: float = 0.6

## Vehicle mass in kilograms — feeds collision response (heavier vehicles
## resist spin-outs and punch through lighter ones on impact).
@export var mass: float = 1000.0
