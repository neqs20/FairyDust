extends TabContainer

onready var SettingsWindow : WindowDialog = get_parent()
onready var SensSlider : HSlider = $Input/Control/MouseSensitivity/Input.SensSlider

func _on_SettingsWindow_visibility_changed() -> void:
	if not SettingsWindow.is_visible_in_tree():
		Config.set_mouse_sensitivity(SensSlider.value)

