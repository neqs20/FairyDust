extends Button

onready var options_window = $"../options_window"

func _on_config_button_pressed():
	options_window.hide() if options_window.is_visible() else options_window.show()
	print("config_button: pressed,toggling options window")