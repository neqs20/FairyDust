extends VBoxContainer


const buttons := []


func _ready() -> void:
	for keybind in KeyBinds.create_key_binds_buttons():
		add_child(keybind, true)

		buttons.push_back(keybind.get_node(keybind.name))

	for i in range(buttons.size()):
		buttons[i].connect("gui_input", self, "_on_key_bind_gui_input", [i])

func _process(delta):
	if Input.is_action_just_pressed("move_forward"):
		print("YEAH")

func _on_key_bind_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventKey:
		if not buttons[index].pressed:
			return

		if event.pressed:
			buttons[index].text = OS.get_scancode_string(event.get_scancode_with_modifiers())

			match event.scancode:
				KEY_CONTROL, KEY_SHIFT, KEY_ALT, KEY_MASK_META, KEY_ESCAPE:
					buttons[index].text = ""
				_:
					_change_key(buttons[index].name, event)

			return

		buttons[index].pressed = false
	elif event is InputEventMouseButton:
		for i in range(buttons.size()):
			if i == index: 
				continue

			buttons[i].pressed = false

func _change_key(action : String, event : InputEventKey) -> void:
	InputMap.action_erase_events(action)
	
	var actions = KeyBinds.BINDS.keys()

	for i in range(actions.size()):
		if not InputMap.action_has_event(actions[i], event):
			continue

		InputMap.action_erase_event(actions[i], event)

		buttons[i].text = ""

	InputMap.action_add_event(action, event)

	KeyBinds.BINDS[action]["scancode"] = event.scancode
	KeyBinds.BINDS[action]["alt"] = event.alt
	KeyBinds.BINDS[action]["shift"] = event.shift
	KeyBinds.BINDS[action]["control"] = event.control
	
