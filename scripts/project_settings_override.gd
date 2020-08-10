## Project Settigns Override
## @desc:
##     Reads `override.cfg` file located in exectubale path.
extends AbstractConfig


func _init() -> void:
	path = OS.get_executable_path().get_base_dir()
	file_name = "override.cfg"


func _enter_tree() -> void:
	if config.load(path.plus_file(file_name)) == OK:
		is_loaded = true


func get_resolution() -> Vector2:
	return Vector2(get_value("display", "window/size/width", -1.0),
			get_value("display", "window/size/height", -1.0))


func set_resolution(value: Vector2) -> void:
	set_value("display", "window/size/width", value.x)
	set_value("display", "window/size/height", value.y)


func _exit_tree() -> void:
	config.save(path.plus_file(file_name))
