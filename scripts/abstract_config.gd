class_name AbstractConfig
extends Node

## A path to the config file
var path: String
# A config file name
var file_name: String

var config := ConfigFile.new()

var is_loaded := false


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
