extends Control

var pressed = false

func _ready():
	$CharacterList/Description/name/left.get_font("font").set_size(30 * (get_viewport().get_size().x / 1920))

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT :
		pressed = event.pressed
	if event is InputEventMouseMotion:
		if pressed:
			$world_3d/character.rotate_y(deg2rad(event.relative.x * 10) * get_physics_process_delta_time())

