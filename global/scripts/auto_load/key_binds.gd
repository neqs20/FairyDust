## Key Binds
extends Node


func _ready() -> void:
	for action in Config.get_input_map_section_keys():
		# if action exist skip interation
		if not InputMap.has_action(action):
			continue
		# get key input from config
		var input = Config.get_value("INPUT_MAP", action, InputEventKey.new())
		# if input exists in any action skip interation
		if has_event(input):
			continue
		# turn of modifiers if they're false
		if not input.alt and not input.shift and not input.control:
			input.action_pressed_on_modifier = false
		input.pressed = true 
		# erase all events from action and new one
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, input)

## Returns true if event exists in any action
func has_event(event: InputEventKey) -> bool:
	for caction in InputMap.get_actions():
		# get all InputEvents from input map
		var input = InputMap.get_action_list(caction)
		# if there's none skip
		if input.size() == 0:
			continue
		# only get the first one
		input = input.back()
		if input.scancode == event.scancode and input.control == event.control and \
				input.alt == event.alt and input.shift == event.shift:
			return true
	return false


func _exit_tree() -> void:
	for action in InputMap.get_actions():
		var inputs = InputMap.get_action_list(action)
		if not inputs.empty():
			Config.set_value("INPUT_MAP", action, inputs.back())
