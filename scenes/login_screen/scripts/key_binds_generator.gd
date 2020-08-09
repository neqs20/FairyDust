## Key Binds Generator
## @desc:
##     Generates [Label]'s and [Button]'s that represents [InputMap]
tool
extends Node


func _ready() -> void:
	generate_map()


## Creates [Label]s and [Button]s
func generate_map() -> void:
	var font = preload("res://assets/fonts/ubuntu/normal14.tres")
	var Labels = $Labels
	var Buttons = $Buttons
	var actions = InputMap.get_actions()
	actions.sort()
	for action in actions:
		var label = Label.new()
		label.text = action.capitalize()
		label.align = Label.ALIGN_LEFT
		label.valign = Label.ALIGN_CENTER
		label.set("custom_fonts/font", font)
		Labels.add_child(label)

		var button = Button.new()
		button.text = InputMap.get_action_list(action).back().as_text()
		button.name = action
		button.toggle_mode = true
		button.set("custom_fonts/font", font)
		Buttons.add_child(button, true)

		label.rect_min_size.y = button.rect_size.y
