class_name InputSource
extends RefCounted
## Wraps a single physical input device (keyboard or one gamepad) and exposes
## a normalized, per-vehicle input read.
##
## `extends RefCounted` (not Node): this class holds no scene-tree state and
## needs no per-frame engine callback of its own — the vehicle controller
## pulls a fresh reading from it once per physics tick via get_input().
##
## Per Architecture Decision 01 (docs/architecture/overview.md), vehicles
## must never poll Input.* globally — they own an InputSource keyed to a
## device instead, so splitscreen/bots/network input can plug in later
## without touching vehicle code.
##
## Device-scoping limitation (Godot 4.7):
## InputMap actions are global and NOT device-scoped — the actions defined
## in project.godot's [input] section (throttle/brake/steer_left/
## steer_right/drift) bind BOTH a keyboard key AND a joypad input to the
## SAME action name. That means Input.is_action_pressed("throttle") fires
## for ANY device's throttle input, not just one — there is no supported
## way to ask "did this action fire from this specific joypad" through the
## action-map API. To get real per-device isolation this class uses two
## different read paths depending on `device`:
##   - device == KEYBOARD_DEVICE (-1): read the shared action map directly
##     via Input.get_action_strength()/is_action_pressed(). Fine for the
##     keyboard slot, since only one human plays keyboard at a time.
##   - device >= 0 (a real joypad id): bypass the action map entirely and
##     poll Input.get_joy_axis(device, ...) / Input.is_joy_button_pressed(
##     device, ...) directly, using the same physical buttons/axes that the
##     actions in project.godot were bound to. This is what actually scopes
##     input to one controller among several.

## Sentinel device id meaning "keyboard", read through the global action map.
const KEYBOARD_DEVICE: int = -1

## Physical joypad bindings mirrored from project.godot's [input] section.
## Used only by the raw-polling path (device >= 0).
const JOY_AXIS_THROTTLE := JOY_AXIS_TRIGGER_RIGHT
const JOY_AXIS_BRAKE := JOY_AXIS_TRIGGER_LEFT
const JOY_AXIS_STEER := JOY_AXIS_LEFT_X
const JOY_BUTTON_DRIFT := JOY_BUTTON_A

## Analog sticks/triggers can rest slightly off zero on real hardware;
## ignore magnitudes below this as noise.
const AXIS_DEADZONE: float = 0.15

## The device this source reads from: KEYBOARD_DEVICE (-1) for keyboard,
## or a joypad device id (0, 1, 2, ...) as reported by Input.get_connected_joypads().
var device: int = KEYBOARD_DEVICE


func _init(p_device: int = KEYBOARD_DEVICE) -> void:
	device = p_device


## Returns a snapshot of this device's current input, normalized as:
##   "throttle": float, -1.0..1.0 (positive = accelerate, negative = brake/reverse)
##   "steer":    float, -1.0..1.0 (negative = left, positive = right)
##   "drift":    bool
func get_input() -> Dictionary[String, Variant]:
	if device == KEYBOARD_DEVICE:
		return _get_input_from_action_map()
	return _get_input_from_joypad()


func _get_input_from_action_map() -> Dictionary[String, Variant]:
	var throttle_strength: float = Input.get_action_strength("throttle")
	var brake_strength: float = Input.get_action_strength("brake")
	var steer_strength: float = Input.get_axis("steer_left", "steer_right")
	var drift_pressed: bool = Input.is_action_pressed("drift")
	return {
		"throttle": clampf(throttle_strength - brake_strength, -1.0, 1.0),
		"steer": steer_strength,
		"drift": drift_pressed,
	}


func _get_input_from_joypad() -> Dictionary[String, Variant]:
	var throttle_strength: float = _apply_deadzone(Input.get_joy_axis(device, JOY_AXIS_THROTTLE))
	var brake_strength: float = _apply_deadzone(Input.get_joy_axis(device, JOY_AXIS_BRAKE))
	var steer_strength: float = _apply_deadzone(Input.get_joy_axis(device, JOY_AXIS_STEER))
	var drift_pressed: bool = Input.is_joy_button_pressed(device, JOY_BUTTON_DRIFT)
	return {
		"throttle": clampf(throttle_strength - brake_strength, -1.0, 1.0),
		"steer": steer_strength,
		"drift": drift_pressed,
	}


func _apply_deadzone(value: float) -> float:
	if absf(value) < AXIS_DEADZONE:
		return 0.0
	return value
