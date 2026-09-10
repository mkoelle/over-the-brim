class_name VehicleController
extends CharacterBody3D
## Arcade-style drivable vehicle body.
##
## Reads a per-device `InputSource` (Architecture Decision 01 —
## docs/architecture/overview.md — vehicles never poll `Input.*` globally)
## and a data-driven `VehicleStats` resource (docs/design/vehicles.md's
## Technical Implementation section) to move a `CharacterBody3D` with
## simple forward acceleration/braking, speed-scaled steering, and a
## drift slip that lets velocity lag behind the facing direction.
##
## No EventBus signals are emitted yet — that lands with the main.tscn
## wiring task, not here.

## Data-driven tuning knobs (max speed, acceleration, steering, drift grip,
## mass). Assign a VehicleStats .tres in the Inspector.
@export var stats: VehicleStats

## Per-device input reader. Not exported — InputSource isn't a Resource,
## so whoever spawns this vehicle assigns it. Defaults to keyboard so the
## node is drivable standalone with no external wiring.
var input_source: InputSource = InputSource.new()

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)


func _physics_process(delta: float) -> void:
	var input: Dictionary[String, Variant] = input_source.get_input()
	var throttle: float = float(input.get("throttle", 0.0))
	var steer: float = float(input.get("steer", 0.0))
	var drift: bool = bool(input.get("drift", false))

	var forward: Vector3 = -transform.basis.z
	var flat_velocity: Vector3 = Vector3(velocity.x, 0.0, velocity.z)
	var current_speed: float = flat_velocity.dot(forward)

	# --- Acceleration / braking along the vehicle's forward basis ---
	if throttle >= 0.0:
		current_speed += throttle * stats.acceleration * delta
	else:
		current_speed += throttle * stats.braking_force * delta
	current_speed = clampf(current_speed, -stats.max_speed, stats.max_speed)

	var target_flat_velocity: Vector3 = forward * current_speed

	# --- Drift: let velocity retain more of its previous direction than
	# the new forward-aligned target, instead of snapping fully onto it. ---
	if drift:
		flat_velocity = flat_velocity.lerp(target_flat_velocity, stats.drift_grip)
	else:
		flat_velocity = target_flat_velocity

	velocity.x = flat_velocity.x
	velocity.z = flat_velocity.z

	# --- Steering: yaw rate scales with steer input and how fast we're
	# going (arcade-style — no spinning in place at a standstill). Scaled by
	# signf(current_speed) so steer_right always curves the actual path
	# right on screen, forward or reverse — real cars invert this in
	# reverse (turn the wheel right, the nose swings right but the car
	# actually travels left), which reads as broken controls in a casual
	# party game. "Fun > Realism" (docs/design/game-pillars.md) wins here. ---
	var speed_factor: float = clampf(absf(current_speed) / stats.max_speed, 0.0, 1.0)
	var yaw: float = -steer * stats.steering_rate * speed_factor * delta * signf(current_speed)
	rotate_y(yaw)

	# --- Gravity ---
	if not is_on_floor():
		velocity.y -= _gravity * delta
	else:
		velocity.y = 0.0

	move_and_slide()
