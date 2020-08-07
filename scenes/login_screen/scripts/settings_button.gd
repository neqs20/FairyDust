## Settings Button Handler
extends Button


onready var SettingsWindow: WindowDialog = $"/root/LoginScreen/SettingsWindow"

## Position and size of [member SettingsWindow]
const popup_size := Rect2(15, 35, 450, 550)


## Called when self is toggled
func _on_Settings_toggled(button_pressed: bool) -> void:
	if not SettingsWindow.visible and button_pressed:
		 SettingsWindow.popup(popup_size)


## Called when [member SettingsWindow] is about to hide
func _on_SettingsWindow_popup_hide() -> void:
	pressed = false
