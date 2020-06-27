extends VBoxContainer

var buttons : Array = []

func _ready() -> void:
	for keybind in KeyBinds.create_key_binds_buttons():
		add_child(keybind, true)
		buttons.push_back(keybind.get_node(keybind.name)) # it's ok to use `get_node` here since it's a `_ready` function
	for i in range(buttons.size()):
		buttons[i].connect("gui_input", self, "_on_key_bind_gui_input", [i])

func _process2(delta):
	if Input.is_action_just_pressed("move_forward"):
		print("Moving Forward")
	elif Input.is_action_just_pressed("move_backwards"):
		print("Moving Backwards")
	elif Input.is_action_just_pressed("rotate_left"):
		print("Rotating Left")
	elif Input.is_action_just_pressed("rotate_right"):
		print("Rotating Right")
	elif Input.is_action_just_pressed("strafe_left"):
		print("Strafing Left")
	elif Input.is_action_just_pressed("strafe_right"):
		print("Strafing Right")

func _on_key_bind_gui_input(event : InputEvent, index : int) -> void:
	if event is InputEventKey:
		if buttons[index].pressed:
			if event.pressed:
				buttons[index].text = OS.get_scancode_string(event.get_scancode_with_modifiers())
				match event.scancode:
					KEY_CONTROL, KEY_SHIFT, KEY_ALT, KEY_MASK_META, KEY_ESCAPE:
						buttons[index].text = ""
					_:
						change_key(buttons[index].name, event)
			else:
				buttons[index].pressed = false
				pass
	elif event is InputEventMouseButton: #!IMPORTANT: Mouse buttons is not enough probably
		for i in range(buttons.size()):
				if i == index: continue
				buttons[i].pressed = false

func change_key(action : String, event : InputEventKey) -> void:
	InputMap.action_erase_events(action) #remove all keybinds from action
	var actions = KeyBinds.BINDS.keys()
	for i in range(actions.size()):
		if InputMap.action_has_event(actions[i], event):
			InputMap.action_erase_event(actions[i], event)
			buttons[i].text = ""
	InputMap.action_add_event(action, event)
	KeyBinds.BINDS[action]["scancode"] = event.scancode
	KeyBinds.BINDS[action]["alt"] = event.alt
	KeyBinds.BINDS[action]["shift"] = event.shift
	KeyBinds.BINDS[action]["control"] = event.control
	
