extends Node

onready var Value : LineEdit = $Value
onready var SensSlider : HSlider = $Slider

func _ready() -> void:
	SensSlider.value = Config.get_mouse_sensitivity()
	Value.text = str(SensSlider.value)

func _on_Slider_value_changed(value : float) -> void:
	Value.text = str(value)

func _on_Value_focus_exited() -> void:
	update_slider()

func _on_Value_text_entered(new_text):
	update_slider()

func update_slider() -> void:
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
