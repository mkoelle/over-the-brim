extends GdUnitTestSuite

## Smoke test: the app boots. Loads the root scene and confirms it
## initializes without errors before any gameplay systems exist to test.

func test_main_scene_loads() -> void:
	var runner := scene_runner("res://scenes/main.tscn")
	assert_object(runner.scene()).is_instanceof(Main)
