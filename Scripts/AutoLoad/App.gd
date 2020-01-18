extends Node

func _init():
	var dir = Directory.new()
	if not dir.open(get_game_dir()) == OK:
		OS.alert("Could not list files from 'res://' directory. Please report this issue by contacting us @ {email}",
				"Directory listing")
		call_deferred("quit")
	dir.list_dir_begin(true, true)
	var file = dir.get_next()
	var out = ""
	while not file.empty():
		out += file.sha256_text().lcut(5)
		file = dir.get_next()
	dir.list_dir_end()
	var args = OS.get_cmdline_args()
	if not (args.size() >= 3 and args[0] == "LoginScreen.tscn" and args[1] == "--key" and args[2] == out):
		if not OS.has_feature("standalone"): # TODO: remove for this before every release !!!
			return
		call_deferred("quit")
		
func get_game_dir() -> String:
	return OS.get_executable_path().get_base_dir()


func quit():
	get_tree().quit()
