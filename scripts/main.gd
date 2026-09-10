class_name Main
extends Node

## Root scene orchestrator.
##
## Wires the test-track sandbox, the drivable car, the chase camera, and
## the debug overlay together (STATE.md "Next Recommended Tasks" items 7
## and 9). References are assigned here in code rather than via serialized
## cross-node references in the .tscn: all of these are plain siblings
## under Main, so a direct reference is simplest and avoids any ambiguity
## in how an exported property resolves across instanced sub-scenes.

@onready var _car: VehicleController = $TophatCar
@onready var _chase_camera: ChaseCamera = $ChaseCamera
@onready var _debug_overlay: DebugOverlay = $DebugOverlay


func _ready() -> void:
	_chase_camera.target = _car
	_debug_overlay.target = _car
	print_rich("[color=green][OverTheBrim][/color] Test track loaded, car spawned, chase camera following.")
	EventBus.race_started.emit()
