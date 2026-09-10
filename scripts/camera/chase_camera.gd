class_name ChaseCamera
extends Camera3D
## Simple trailing chase camera for the drivable prototype (STATE.md
## "Next Recommended Tasks" item 6).
##
## Deliberately NOT the full PresenterDirector/ViewportManager broadcast
## camera rig described in docs/architecture/overview.md (Smart Cameras,
## PiP, multi-viewport splitscreen) — that's spectator/broadcast machinery
## with no reason to exist before one car is fun to drive. This is a
## single Camera3D that trails whatever Node3D is assigned to `target`.
##
## `extends Camera3D` directly, not `Node3D` with a child `Camera3D`: the
## only per-frame work is "compute one desired world position + look
## rotation, then move/rotate toward it" — there's no separate rig pivot
## or offset that would benefit from an extra Node3D layer, so the plain
## Camera3D is the simplest option that fully covers the behavior.
##
## Runs in `_physics_process`, not `_process`, to match VehicleController's
## physics-step cadence (scripts/vehicles/vehicle_controller.gd) — sampling
## the target's transform on a different cadence than it's produced would
## make the camera visually lead/lag the car it's chasing.

## The vehicle (or other Node3D) to follow. Assigned externally by whatever
## spawns this camera (e.g. the main.tscn wiring task) — never hardcoded to
## a specific scene/node path.
@export var target: Node3D

## Desired distance behind the target, in meters, measured along the
## target's current -Z (forward) axis — so the offset trails wherever the
## car is pointed, not a fixed world-space direction.
@export var follow_distance: float = 6.0

## Desired height above the target, in meters.
@export var follow_height: float = 2.5

## Position smoothing rate, in 1/seconds — higher follows the desired spot
## more tightly, lower trails looser. Framerate-independent: applied as an
## exponential-decay lerp weight (1 - exp(-rate * delta)) rather than a
## fixed per-frame fraction, so behavior doesn't change with physics tick
## rate.
@export var follow_smoothing: float = 6.0

## Look-at smoothing rate, in 1/seconds, same shape as follow_smoothing but
## applied to the camera's rotation toward the target instead of position.
@export var look_smoothing: float = 8.0

## No collision/clipping-avoidance against level geometry yet — deferred
## to a future polish pass; a simple trailing offset is enough for this
## milestone (STATE.md task 6).

## Whether the camera has snapped to its target at least once. Avoids a
## long, slow fly-in from wherever the camera happened to be placed in the
## editor the first time a target becomes available.
var _has_snapped: bool = false


func _physics_process(delta: float) -> void:
	if target == null:
		return

	var desired_position: Vector3 = _compute_desired_position()
	var desired_basis: Basis = _compute_desired_look_basis(desired_position)

	if not _has_snapped:
		global_position = desired_position
		global_transform.basis = desired_basis
		_has_snapped = true
		return

	global_position = global_position.lerp(desired_position, _decay_weight(follow_smoothing, delta))
	global_transform.basis = global_transform.basis.slerp(desired_basis, _decay_weight(look_smoothing, delta))


func _compute_desired_position() -> Vector3:
	var target_transform: Transform3D = target.global_transform
	var forward: Vector3 = -target_transform.basis.z
	return target_transform.origin - forward * follow_distance + Vector3.UP * follow_height


func _compute_desired_look_basis(from_position: Vector3) -> Basis:
	var to_target: Vector3 = target.global_position - from_position
	if to_target.length_squared() < 0.0001:
		return global_transform.basis
	return Basis.looking_at(to_target, Vector3.UP)


## Exponential-decay smoothing weight for lerp/slerp: converges toward 1.0
## as delta or rate grows, independent of frame rate.
func _decay_weight(rate: float, delta: float) -> float:
	return 1.0 - exp(-rate * delta)
