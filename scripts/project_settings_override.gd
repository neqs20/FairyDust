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


func is_fullscreen() -> bool:
	return get_value("display", "window/size/fullscreen", false)


func set_fullscreen(value: bool) -> void:
	set_value("display", "window/size/fullscreen", value)


func get_msaa() -> int:
	return get_value("rendering", "quality/filters/msaa", Viewport.MSAA_DISABLED)


func set_msaa(value: int) -> void:
	set_value("rendering", "quality/filters/msaa", value)


func get_vsync() -> bool:
	return get_value("display", "window/vsync/use_vsync", false)


func set_vsync(value: bool) -> void:
	set_value("display", "window/vsync/use_vsync", value)


func get_font_oversampling() -> bool:
	return get_value("rendering", "quality/dynamic_fonts/use_oversampling", true)


func set_font_oversampling(value: bool) -> void:
	set_value("rendering", "quality/dynamic_fonts/use_oversampling", value)


func _exit_tree() -> void:
	config.save(path.plus_file(file_name))
