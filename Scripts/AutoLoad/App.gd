extends Node

func get_game_dir() -> String:
	return OS.get_executable_path().get_base_dir()


func quit():
	get_tree().quit()
