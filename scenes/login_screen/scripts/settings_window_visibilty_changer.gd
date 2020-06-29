extends Control


const DEFAULT_POSITION := Vector2(15, 25)

onready var SettingsWindow : WindowDialog = $SettingsWindow
onready var SettingsButton : Button = $Settings


func _on_Settings_pressed() -> void:
	if SettingsWindow.is_visible_in_tree():
		SettingsWindow.hide()
		return

	SettingsWindow.set_position(DEFAULT_POSITION)
	SettingsWindow.show()
