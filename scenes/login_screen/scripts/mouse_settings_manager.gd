## Mouse Settings Manager
extends HBoxContainer


onready var Value: LineEdit = $Value
onready var SensSlider: HSlider = $Slider


func _ready() -> void:
	SensSlider.value = Config.get_mouse_sensitivity()

	Value.text = str(SensSlider.value)


## Called when value changes for [HSlider]
func _on_Slider_value_changed(value: float) -> void:
	Value.text = str(value)


## Called when [LineEdit] loses focus
func _on_Value_focus_exited() -> void:
	# Don't update if it was already updated or value did not change
	if not is_equal_approx(SensSlider.value, float(Value.text)):
		_update_slider()


## Called when Enter is pressed on [LineEdit]
func _on_Value_text_entered(new_text: String) -> void:
	_update_slider()


## Updates [HSlider] value based on [LineEdit] input
func _update_slider() -> void:
	# Loop through all characters
	var i := 0
	while i < Value.text.length():
		# Skip if char is a valid integer or is a dot (for floats)
		if Value.text[i].is_valid_integer() or Value.text[i] == ".":
			i += 1
			continue
		# It's a character so delete it
		Value.text.erase(i, 1)
		i += 1
	Value.text = str(clamp(float(Value.text), SensSlider.min_value, SensSlider.max_value))

	SensSlider.value = float(Value.text)
	Value.release_focus()


func _exit_tree() -> void:
	Config.set_mouse_sensitivity(SensSlider.value)
