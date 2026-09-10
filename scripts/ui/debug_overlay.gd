class_name DebugOverlay
extends CanvasLayer
## Developer-only readout: speed, live input, FPS. Gated behind
## GameConfig.debug_mode (off by default, toggled at runtime with F3) —
## never shown to players. See docs/standards/manual-testing.md.
##
## Reads VehicleController.last_input rather than polling Input.* itself,
## so this shows exactly what the car is actually reacting to (Architecture
## Decision 01 — the car never polls Input.* globally either).

## The vehicle to read telemetry from. Assigned externally (e.g. main.gd),
## same pattern as ChaseCamera.target.
@export var target: VehicleController

@onready var _label: Label = $PanelContainer/Label


func _process(_delta: float) -> void:
	visible = GameConfig.debug_mode
	if not visible or target == null:
		return

	var flat_velocity: Vector3 = Vector3(target.velocity.x, 0.0, target.velocity.z)
	var speed: float = flat_velocity.length()
	var throttle: float = float(target.last_input.get("throttle", 0.0))
	var steer: float = float(target.last_input.get("steer", 0.0))
	var drift: bool = bool(target.last_input.get("drift", false))

	_label.text = "Speed: %.1f / %.1f m/s\nThrottle: %+.2f\nSteer: %+.2f\nDrift: %s\nFPS: %d" % [
		speed,
		target.stats.max_speed,
		throttle,
		steer,
		"YES" if drift else "no",
		Engine.get_frames_per_second(),
	]
