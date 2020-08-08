## Config
## @desc:
##     Wrapper of [ConfigFile].
##     
extends Node


## A path to the file
const PATH := "user://settings.ini"


var config := ConfigFile.new()
var is_loaded := false


func _enter_tree() -> void:
	var error = config.load(PATH)
	if not error == OK:
		if error == ERR_FILE_NOT_FOUND:
			Logger.info(Messages.CONFIG_FILE_NOT_FOUND, [PATH])
		else:
			Logger.error(Messages.CONFIG_FILE_ERROR, [PATH, error])
			return
	is_loaded = true

## Returns a value located under [param section] with a [param key].
## If config is not loaded or entry doesn't exist or 
## types aren't matching returns default.
func get_value(section: String, key: String, default):
	if is_loaded:
		var v = config.get_value(section, key, default)
		if typeof(v) == typeof(default):
			return v
	return default


## Sets a value in given [param section] and [param key]. If config is not loaded
## does nothing
func set_value(section: String, key: String, value) -> void:
	if is_loaded:
		config.set_value(section, key, value)

## Returns [Array] of [String]s (keys) from [param section]. If section doesn't
## exists or doesn't have any keys returns empty array
func get_section_keys(section: String) -> Array:
	if is_loaded:
		if config.has_section(section):
			return Array(config.get_section_keys(section))
	return []


func get_resolution() -> Vector2:
	return get_value("GRAPHICS", "resolution", Vector2(0, 0))


func set_resolution(resolution: Vector2) -> void:
	set_value("GRAPHICS", "resolution", resolution)


func get_save_id() -> bool:
	return get_value("LOGIN", "save_id", false)


func set_save_id(state: bool) -> void:
	set_value("LOGIN", "save_id", state)


func get_username() -> String:
	return get_value("LOGIN", "username", "")


func set_username(value: String) -> void:
	set_value("LOGIN", "username", value)


func get_version() -> String:
	return get_value("MISC", "version", "0.0.0") 


func set_version(value: String) -> void:
	set_value("MISC", "version", value)


func get_ip() -> String:
	return get_value("NETWORK", "ip", "127.0.0.1")


func set_ip(value: String) -> void:
	set_value("NETWORK", "ip", value)


func get_port() -> int:
	return get_value("NETWORK", "port", 4444)


func set_port(value: int) -> void:
	set_value("NETWORK", "port", value)


func get_mouse_sensitivity() -> float:
	return get_value("INPUT", "mouse_sensitivity", 5.0)


func set_mouse_sensitivity(value: float) -> void:
	set_value("INPUT", "mouse_sensitivity", value)


func get_input_map_section_keys() -> Array:
	return get_section_keys("INPUT_MAP")


func _exit_tree() -> void:
	if not config.save(PATH) == OK:
		Logger.error(Messages.CONFIG_SAVE_FAIL, [PATH])
		
