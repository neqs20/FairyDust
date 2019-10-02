extends Button

#Root of the Scene
onready var options_window = $"../../../.."

func _on_options_exit_pressed():
	options_window.hide()

