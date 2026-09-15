extends Node

## Global configuration and settings constants.

## Gates DebugOverlay (scenes/ui/debug_overlay.tscn) and any other
## developer-only readouts. Off by default — never ships on for players.
## Toggle at runtime with F3 so testers don't need an editor round-trip.
var debug_mode: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.physical_keycode == KEY_F3
	):
		debug_mode = not debug_mode
		print_rich("[color=yellow][GameConfig][/color] debug_mode = ", debug_mode)
