extends Node


onready var Value: LineEdit = $Value
onready var SensSlider: HSlider = $Slider


func _ready() -> void:
	SensSlider.value = Config.get_mouse_sensitivity()

	Value.text = str(SensSlider.value)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		Config.set_mouse_sensitivity(SensSlider.value)


func _on_Slider_value_changed(value: float) -> void:
	Value.text = str(value)


func _on_Value_focus_exited() -> void:
	_update_slider()


func _on_Value_text_entered(new_text: String) -> void:
	_update_slider()


func _update_slider() -> void:
	for i in range(Value.text.length()):
		if not i < Value.text.length():
			break

		if Value.text[i].is_valid_integer() or Value.text[i] == ".":
			continue

		Value.text[i] = ""

	Value.text = str(clamp(float(Value.text), SensSlider.min_value, SensSlider.max_value))
	Value.release_focus()

	SensSlider.value = float(Value.text)
