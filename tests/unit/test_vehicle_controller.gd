extends GdUnitTestSuite

## Real behavioral coverage for VehicleController (STATE.md's Next Recommended
## Tasks item 8), replacing reliance on the boot-only smoke test in
## tests/integration/test_main.gd.
##
## Input is driven through the scene_runner's simulate_action_press()/
## simulate_action_release(), the same pattern tests/integration/test_main.gd
## uses for scene_runner()/simulate_frames(). Under the hood
## GdUnitSceneRunnerImpl calls Input.action_press("throttle", 1.0) /
## Input.action_release("throttle") on the shared global action map
## (see addons/gdUnit4/src/core/GdUnitSceneRunnerImpl.gd:126-143,554-561) —
## which is exactly the action map InputSource._get_input_from_action_map()
## reads via Input.get_action_strength()/is_action_pressed() for the default
## keyboard device (input_source.gd:66-75). That means this exercises the
## real keyboard InputSource code path end to end with no fake/stub needed,
## and is more reliable under scene_runner than calling global
## Input.action_press() directly, since the runner also tracks and
## auto-releases any action left pressed when it is disposed
## (GdUnitSceneRunnerImpl.gd:592-608). We still explicitly release the
## action at the end of every test as a belt-and-suspenders guard against
## state leaking into the next test case, per this project's convention of
## deterministic per-test cleanup.

const TOPHAT_CAR_SCENE := "res://scenes/vehicles/tophat_car.tscn"

## 3 seconds at the default 60 Hz physics tick — comfortably past
## stats.max_speed / stats.acceleration (~1.7s for the Stovepipe Speedster)
## so the clamp in vehicle_controller.gd is actually exercised, not just
## the ramp-up.
const THROTTLE_FRAMES := 180


func test_loads_without_error() -> void:
	var runner := scene_runner(TOPHAT_CAR_SCENE)
	var car: VehicleController = runner.scene()

	assert_object(car).is_instanceof(VehicleController)
	assert_object(car.stats).is_instanceof(VehicleStats)
	assert_object(car.stats).is_not_null()


func test_accelerates_under_throttle_and_respects_max_speed() -> void:
	var runner := scene_runner(TOPHAT_CAR_SCENE)
	var car: VehicleController = runner.scene()
	var start_position: Vector3 = car.global_position

	runner.simulate_action_press("throttle")
	await runner.simulate_frames(THROTTLE_FRAMES)

	var forward: Vector3 = -car.global_transform.basis.z
	var flat_velocity: Vector3 = Vector3(car.velocity.x, 0.0, car.velocity.z)
	var forward_speed: float = flat_velocity.dot(forward)

	# Moved forward from the start position (horizontal plane only — the
	# car has no floor under it in this standalone instantiation, so it
	# also falls under gravity; that vertical motion isn't what this
	# assertion is about).
	var flat_displacement: Vector3 = Vector3(
		car.global_position.x - start_position.x,
		0.0,
		car.global_position.z - start_position.z
	)
	assert_float(flat_displacement.length()).is_greater(0.0)

	# Actually accelerated, and never exceeds the configured cap — this is
	# the clampf(...) in vehicle_controller.gd's _physics_process actually
	# doing its job.
	assert_float(forward_speed).is_greater(0.0)
	assert_float(forward_speed).is_less_equal(car.stats.max_speed)

	runner.simulate_action_release("throttle")


func test_no_nan_or_inf_during_sustained_throttle() -> void:
	var runner := scene_runner(TOPHAT_CAR_SCENE)
	var car: VehicleController = runner.scene()

	runner.simulate_action_press("throttle")
	await runner.simulate_frames(THROTTLE_FRAMES)

	var position: Vector3 = car.global_position
	var velocity: Vector3 = car.velocity

	assert_bool(is_finite(position.x)).is_true()
	assert_bool(is_finite(position.y)).is_true()
	assert_bool(is_finite(position.z)).is_true()
	assert_bool(is_finite(velocity.x)).is_true()
	assert_bool(is_finite(velocity.y)).is_true()
	assert_bool(is_finite(velocity.z)).is_true()

	runner.simulate_action_release("throttle")
