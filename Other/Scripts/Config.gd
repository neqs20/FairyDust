extends Node

const default = {
	"save_id" : true,
	"login_field" : "",
}


var current = {}

var default_config_path = "user://default.cfg"

func _ready():
	current = prepare(default_config_path)

func prepare(file : String) -> Dictionary:
	var config = File.new()
	if !config.file_exists(file):
		print("Config file does not exist. Creating... ")
		config.open(file , File.WRITE)
		config.store_line(to_json(default))
		config.close()
		return default
	config.open(file, File.READ)
	var parsed_config = parse_json(config.get_line())
	config.close()
	return parsed_config
	
func update(key : String, value):
	current[key] = value
	print("Config: updating")
	
func save():
	var config = File.new()
	config.open(default_config_path,File.WRITE)
	config.store_line(to_json(current))
	config.close()