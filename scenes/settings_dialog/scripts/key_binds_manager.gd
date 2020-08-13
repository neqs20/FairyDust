## Key Binds Manager
extends VBoxContainer


## An array of [Button]s.
onready var buttons: Array = $ScrollContainer/HBoxContainer/Buttons.get_children()


func _ready() -> void:
	for button in buttons:
		button.connect("gui_input", self, "_on_key_bind_gui_input", [button])


## Called when one of [Button]s from [member buttons] receive [signal Control.gui_input].
## [param button] is a reference to that [Button].
func _on_key_bind_gui_input(event: InputEvent, button: Button) -> void:
	# Only InputEventKey is supported.
	# TODO: Add support for InputEventMouseButton.
	if event is InputEventKey:
		# button needs to pressed to bind a key
		if not button.pressed:
			return

		if event.pressed:
			# Remember current key bind
			var last_bind = button.text
			# Display current scancode with modifiers
			button.text = OS.get_scancode_string(event.get_scancode_with_modifiers())
			# Enable modifiers if event has any
			event.action_pressed_on_modifier = event.alt or event.control or event.shift
			match event.scancode:
				# Don't allow binding control, shift and meta key alone
				KEY_CONTROL, KEY_SHIFT, KEY_MASK_META:
					button.text = last_bind
				KEY_ESCAPE:
					if button.name == "ui_cancel":
						_change_key(button.name, event)
					else:
						_erase_key(button)
				_:
					_change_key(button.name, event)
			return
		button.pressed = false
	elif event is InputEventMouseButton:
		for b in buttons:
			if button == b:
				continue
			b.pressed = false


## Deletes every occurence of [param event] and adds [param event] to the [param action]
func _change_key(action: String, event: InputEventKey) -> void:
	# Delete all events from the action
	InputMap.action_erase_events(action)

	# Check if event already exists
	for button in buttons:
		if not InputMap.action_has_event(button.name, event):
			continue
		_erase_key(button)

	# add new event to the action
	InputMap.action_add_event(action, event)


## Deletes all events from action, clears [Button]'s text
func _erase_key(button: Button) -> void:
	InputMap.action_erase_events(button.name)
	button.text = ""
