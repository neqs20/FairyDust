extends TabContainer

onready var Value : LineEdit = $Input/Control/MouseSensitivity/Input/Value
onready var SensSlider : HSlider = $Input/Control/MouseSensitivity/Input/Slider

onready var SettingsWindow : WindowDialog = get_parent()

func _ready() -> void:
	SensSlider.value = Config.get_mouse_sensitivity()
	Value.text = str(SensSlider.value)

func _on_Slider_value_changed(value : float) -> void:
	Value.text = str(value)

func _on_SettingsWindow_visibility_changed() -> void:
	if not SettingsWindow.is_visible_in_tree():
		Config.set_mouse_sensitivity(SensSlider.value)

func _on_Value_focus_exited(_nil):
	for i in range(Value.text.length()):
		if not i < Value.text.length():
			break
		if Value.text[i].is_valid_integer() or Value.text[i] == ".":
			continue
		Value.text[i] = ""
		Value.set_cursor_position(int(clamp(Value.get_cursor_position() + 1, 0, Value.text.length())))
	Value.text = str(clamp(float(Value.text), SensSlider.min_value, SensSlider.max_value))
	SensSlider.value = float(Value.text)
	Value.release_focus()

