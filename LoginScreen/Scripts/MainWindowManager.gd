extends Control

onready var SettingsWindow : WindowDialog = $SettingsWindow
onready var SettingsButton : Button = $Settings


var about_to_hide : bool = false

func _on_Settings_pressed():
	if not SettingsWindow.is_visible_in_tree():
		SettingsWindow.set_position(Vector2(15, 25))
		SettingsWindow.show()
	else:
		SettingsWindow.hide()

