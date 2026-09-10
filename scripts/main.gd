class_name Main
extends Node

## Root scene orchestrator.
##
## Wires the test-track sandbox, the drivable car, and the chase camera
## together (STATE.md "Next Recommended Tasks" item 7). The camera's
## `target` is assigned here in code rather than via a serialized
## cross-node reference in the .tscn: both nodes are plain siblings under
## Main, so a direct reference is simplest and avoids any ambiguity in how
## an exported Node3D property resolves across instanced sub-scenes.

@onready var _car: Node3D = $TophatCar
@onready var _chase_camera: ChaseCamera = $ChaseCamera


func _ready() -> void:
	_chase_camera.target = _car
	print_rich("[color=green][OverTheBrim][/color] Test track loaded, car spawned, chase camera following.")
	EventBus.race_started.emit()
