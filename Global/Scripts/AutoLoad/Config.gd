extends Node

const PATH : String = "user://settings.cfg"

var config = ConfigFile.new()
var is_loaded : bool = false

func _enter_tree():
	var error = config.load(PATH)
	if not error == OK:
		if error == ERR_FILE_NOT_FOUND:
			Logger.info(Errors.CONFIG_FILE_NOT_FOUND, [ PATH ])
		else:
			Logger.error(Errors.CONFIG_FILE_ERROR, [ PATH, error ])
			return
	is_loaded = true

func get_value(section : String, key : String, default):
	if is_loaded:
		return config.get_value(section, key, default)
	return default

func set_value(section : String, key : String, value) -> void:
	if is_loaded:
		config.set_value(section, key, value)

func get_resolution() -> Vector2:
	return get_value("GRAPHICS", "resolution", Vector2(0,0))

func set_resolution(resolution : Vector2) -> void:
	set_value("GRAPHICS", "resolution", resolution)


func get_save_id() -> bool:
	return get_value("LOGIN", "save_id", false)

func set_save_id(state : bool) -> void:
	set_value("LOGIN", "save_id", state)


func get_username() -> String:
	return config.get_value("LOGIN", "username", "")

func set_username(value : String) -> void:
	set_value("LOGIN", "username", value)


func get_version() -> String:
	return get_value("MISC", "version", "0.0.0") 

func set_version(value : String) -> void:
	set_value("MISC", "version", value)


func get_ip() -> String:
	return get_value("NETWORK", "ip", "127.0.0.1")

func set_ip(value : String) -> void:
	set_value("NETWORK", "ip", value)


func get_port() -> int:
	return get_value("NETWORK", "port", 4444)

func set_port(value : int) -> void:
	set_value("NETWORK", "port", value)


func get_mouse_sensitivity() -> float:
	return get_value("INPUT", "mouse_sensitivity", 5)

func set_mouse_sensitivity(value : float) -> void:
	set_value("INPUT", "mouse_sensitivity", value)


func _exit_tree():
	config.save(PATH)
