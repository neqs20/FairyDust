extends VBoxContainer

onready var Buttons = get_tree().get_nodes_in_group("KeyBindButtons")
onready var Actions = get_tree().get_nodes_in_group("ActionLabels")

func _ready():
	set_keys()

func _process(delta):
	if Input.is_action_just_pressed("Move Forward"):
		print("Moving Forward")
	elif Input.is_action_just_pressed("Move Backwards"):
		print("Moving Backwards")
	elif Input.is_action_just_pressed("Rotate Left"):
		print("Rotating Left")
	elif Input.is_action_just_pressed("Rotate Right"):
		print("Rotating Right")
	elif Input.is_action_just_pressed("Strafe Left"):
		print("Strafing Left")
	elif Input.is_action_just_pressed("Strafe Right"):
		print("Strafing Right")

func _on_KeyBind_gui_input(event : InputEvent, index : int) -> void:
	if event is InputEventKey and event.pressed:
		if Buttons[index].pressed:
			if event.scancode == KEY_ESCAPE:
				pass
			else:
				change_key(Actions[index].text, event)
				set_key(index, Actions[index].text)
			Buttons[index].pressed = false
	elif event is InputEventMouseButton:
		for i in range(Buttons.size()):
				if i == index: continue
				Buttons[i].pressed = false

func change_key(action : String, event : InputEvent) -> void:
	InputMap.action_erase_events(action) #remove all keybinds from action
	for i in InputMap.get_actions():
		if InputMap.action_has_event(i, event):
			InputMap.action_erase_event(i, event)
			print(i)
	InputMap.action_add_event(action, event)

func set_keys() -> void:
	for i in range(Buttons.size()):
		set_key(i, Actions[i].text) 

func set_key(index : int, action : String) -> void:
	Buttons[index].text = InputMap.get_action_list(action)[0].as_text()
