## Config
## @desc:
##     Wrapper of [ConfigFile].
##     
extends AbstractConfig


const GRAPHICS_SECTION := "GRAPHICS"
const LOGIN_SECTION := "LOGIN"
const MISCELLANEOUS_SECTION := "MISCELLANEOUS"
const NETWORK_SECTION := "NETWORK"
const CONTROL_SECTION := "CONTROL"
const INPUT_MAP_SECTION := "INPUT_MAP"


func _init() -> void:
	path = OS.get_executable_path().get_base_dir()
	file_name = "settings.ini"

func _enter_tree() -> void:
	var error = config.load(path.plus_file(file_name))
	if not error == OK:
		if error == ERR_FILE_NOT_FOUND:
			Logger.info(Messages.CONFIG_FILE_NOT_FOUND, [path.plus_file(file_name)])
		else:
			Logger.error(Messages.CONFIG_FILE_ERROR, [path.plus_file(file_name), error])
			return
	is_loaded = true


## Returns [Array] of [String]s (keys) from [param section]. If section doesn't
## exists or doesn't have any keys returns empty array
func get_section_keys(section: String) -> Array:
	if is_loaded:
		if config.has_section(section):
			return Array(config.get_section_keys(section))
	return []


func get_save_id() -> bool:
	return get_value(LOGIN_SECTION, "save_id", false)


func set_save_id(state: bool) -> void:
	set_value(LOGIN_SECTION, "save_id", state)


func get_username() -> String:
	return get_value(LOGIN_SECTION, "username", "")


func set_username(value: String) -> void:
	set_value(LOGIN_SECTION, "username", value)


func get_version() -> String:
	return get_value(MISCELLANEOUS_SECTION, "version", "0.0.0") 


func set_version(value: String) -> void:
	set_value(MISCELLANEOUS_SECTION, "version", value)


func get_ip() -> String:
	return get_value(NETWORK_SECTION, "ip", "127.0.0.1")


func set_ip(value: String) -> void:
	set_value(NETWORK_SECTION, "ip", value)


func get_port() -> int:
	return get_value(NETWORK_SECTION, "port", 4444)


func set_port(value: int) -> void:
	set_value(NETWORK_SECTION, "port", value)


func get_mouse_sensitivity() -> float:
	return get_value(CONTROL_SECTION, "mouse_sensitivity", 5.0)


func set_mouse_sensitivity(value: float) -> void:
	set_value(CONTROL_SECTION, "mouse_sensitivity", value)


func get_input_map_section_keys() -> Array:
	return get_section_keys(INPUT_MAP_SECTION)


func _exit_tree() -> void:
	if not config.save(path.plus_file(file_name)) == OK:
		Logger.error(Messages.CONFIG_SAVE_FAIL, [path.plus_file(file_name)])
		
