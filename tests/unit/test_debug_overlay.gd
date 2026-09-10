extends GdUnitTestSuite

## Coverage for GameConfig.debug_mode + DebugOverlay (STATE.md item 9):
## the F3 toggle actually flips the flag, and the overlay's visibility and
## readout track it and the car's live state.

const MAIN_SCENE := "res://scenes/main.tscn"


func before_test() -> void:
	GameConfig.debug_mode = false


func after_test() -> void:
	GameConfig.debug_mode = false


func test_debug_mode_defaults_off() -> void:
	assert_bool(GameConfig.debug_mode).is_false()


func test_f3_toggles_debug_mode() -> void:
	var runner := scene_runner(MAIN_SCENE)

	runner.simulate_key_press(KEY_F3)
	await runner.simulate_frames(2)
	assert_bool(GameConfig.debug_mode).is_true()

	runner.simulate_key_release(KEY_F3)
	runner.simulate_key_press(KEY_F3)
	await runner.simulate_frames(2)
	assert_bool(GameConfig.debug_mode).is_false()


func test_overlay_hidden_by_default_and_visible_when_debug_mode_on() -> void:
	var runner := scene_runner(MAIN_SCENE)
	var main: Node = runner.scene()
	var overlay: CanvasLayer = main.get_node("DebugOverlay")

	await runner.simulate_frames(2)
	assert_bool(overlay.visible).is_false()

	runner.simulate_key_press(KEY_F3)
	await runner.simulate_frames(2)
	assert_bool(overlay.visible).is_true()


func test_overlay_shows_live_speed_and_input() -> void:
	var runner := scene_runner(MAIN_SCENE)
	var main: Node = runner.scene()
	var overlay: CanvasLayer = main.get_node("DebugOverlay")
	var label: Label = overlay.get_node("PanelContainer/Label")

	runner.simulate_key_press(KEY_F3)
	runner.simulate_action_press("throttle")
	await runner.simulate_frames(30)

	assert_str(label.text).contains("Speed:")
	assert_str(label.text).contains("Throttle: +1.00")

	runner.simulate_action_release("throttle")
