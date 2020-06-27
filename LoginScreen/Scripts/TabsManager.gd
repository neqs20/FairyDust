extends TabContainer

onready var SettingsWindow : WindowDialog = get_parent()
onready var SensSlider : HSlider = $Input/Control/MouseSensitivity/Input.SensSlider

func _on_SettingsWindow_visibility_changed() -> void:
	pass

func _exit_tree():
	print(1)
	Config.set_mouse_sensitivity(SensSlider.value)
