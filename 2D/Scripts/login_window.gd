extends Control

export(bool) var controlled_focus = false

func _ready():
	set_position(get_center())
	if controlled_focus:
		if Config.current["save_id"] and !Config.current["login_field"].empty():
			$password_field.grab_focus()
			print("login_window: passsword grab focus")
		else:
			$login_field.grab_focus()
			print("login_window: login grab focus")

func get_center() -> Vector2:
	var size = OS.get_window_size()
	var WIDTH = size.x
	var HEIGHT = size.y
	var w = get_size().x
	var h = 0.75 * HEIGHT
	return Vector2((WIDTH - w) / 2.0, h)
	