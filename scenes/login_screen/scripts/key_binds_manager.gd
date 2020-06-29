extends VBoxContainer


const buttons := []


func _ready() -> void:
	for keybind in _create_key_binds_buttons():
		add_child(keybind, true)

		buttons.push_back(keybind.get_node(keybind.name))

	for i in range(buttons.size()):
		buttons[i].connect("gui_input", self, "_on_key_bind_gui_input", [i])


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_forward"):
		print("FORWARD")
	if Input.is_action_just_pressed("move_backwards"):
		print("BACKWARDS")


func _on_key_bind_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventKey:
		if not buttons[index].pressed:
			return

		if event.pressed:
			buttons[index].text = OS.get_scancode_string(event.get_scancode_with_modifiers())
			event.action_pressed_on_modifier = event.alt or event.control or event.shift
			match event.scancode:
				KEY_CONTROL, KEY_SHIFT, KEY_ALT, KEY_MASK_META:
						buttons[index].text = ""
				KEY_ESCAPE:
					_erase_key(buttons[index].name, index, event)
				_:
					_change_key(buttons[index].name, event)

			return

		buttons[index].pressed = false
	elif event is InputEventMouseButton:
		for i in range(buttons.size()):
			if i == index: 
				continue

			buttons[i].pressed = false

func _change_key(action: String, event: InputEventKey) -> void:
	InputMap.action_erase_events(action)
	
	var actions = KeyBinds.BINDS.keys()

	for i in range(actions.size()):
		if not InputMap.action_has_event(actions[i], event):
			continue
		_erase_key(actions[i], i, event)

	InputMap.action_add_event(action, event)

	KeyBinds.BINDS[action]["scancode"] = event.scancode
	KeyBinds.BINDS[action]["alt"] = event.alt
	KeyBinds.BINDS[action]["shift"] = event.shift
	KeyBinds.BINDS[action]["control"] = event.control


func _erase_key(action: String, index: int, event: InputEventKey) -> void:
	InputMap.action_erase_event(action, event)
	KeyBinds.BINDS[action]["scancode"] = 0
	KeyBinds.BINDS[action]["alt"] = false
	KeyBinds.BINDS[action]["shift"] = false
	KeyBinds.BINDS[action]["control"] = false
	buttons[index].text = ""

func _create_key_binds_buttons() -> Array:
	var ret := []

	for bind in KeyBinds.BINDS:
		var hbox : HBoxContainer = HBoxContainer.new()
		hbox.name = bind

		var action_label : Label = Label.new()
		action_label.valign = Label.VALIGN_CENTER
		action_label.align = Label.ALIGN_CENTER
		action_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		action_label.text = bind.capitalize()
		
		var button : Button = Button.new()
		button.toggle_mode = true
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.text = InputMap.get_action_list(bind).back().as_text()
		button.name = bind

		hbox.add_child(action_label)
		hbox.add_child(button, true)

		ret.push_back(hbox)
	return ret
