extends Node


var BINDS = {
	"move_forward" : {
		"scancode" : KEY_W,
		"alt" : false,
		"shift" : false,
		"control" : false,
	}, 
	"move_backwards" : {
		"scancode" : KEY_S,
		"alt" : false,
		"shift" : false,
		"control" : false,
	}, 
	"strafe_left" : {
		"scancode" : KEY_Q,
		"alt" : false,
		"shift" : false,
		"control" : false,
	}, 
	"strafe_right" : {
		"scancode" : KEY_E,
		"alt" : false,
		"shift" : false,
		"control" : false,
	},
	"rotate_left" : {
		"scancode" : KEY_A,
		"alt" : false,
		"shift" : false,
		"control" : false,
	},
	"rotate_right" : {
		"scancode" : KEY_D,
		"alt" : false,
		"shift" : false,
		"control" : false,
	},
	"jump" : {
		"scancode" : KEY_SPACE,
		"alt" : false,
		"shift" : false,
		"control" : false,
	},
}


func _ready() -> void:
	for action in Config.get_input_map_section_keys():
		if not BINDS.has(action):
			continue
		var new_action = Config.get_value("INPUT_MAP", action, BINDS[action])
		if contains_bind(new_action):
			update_bind(action, 0, false, false, false)
		else:
			BINDS[action] = new_action

	for bind in BINDS:
		InputMap.add_action(bind)

		var input = InputEventKey.new()

		if BINDS[bind].has("scancode"):
			if typeof(BINDS[bind].scancode) == TYPE_INT:
				input.scancode = BINDS[bind].scancode
			if not BINDS[bind].scancode == 0:
				if BINDS[bind].has("alt"):
					if typeof(BINDS[bind].alt) == TYPE_BOOL:
						input.alt = BINDS[bind].alt
				if BINDS[bind].has("shift"):
					if typeof(BINDS[bind].shift) == TYPE_BOOL:
						input.shift = BINDS[bind].shift
				if BINDS[bind].has("control"):
					if typeof(BINDS[bind].control) == TYPE_BOOL:
						input.control = BINDS[bind].control
			
		if not input.alt and not input.shift and not input.control:
			input.action_pressed_on_modifier = false

		input.pressed = true
		InputMap.action_add_event(bind, input)


func contains_bind(bind: Dictionary) -> bool:
	var flag = false
	for bind in BINDS:
		if BINDS[bind].has(bind):
			flag = true
			break
	return flag

func update_bind(action: String, scancode: int, alt: bool, shift: bool, control: bool) -> void:
	KeyBinds.BINDS[action]["scancode"] = scancode
	KeyBinds.BINDS[action]["alt"] = alt
	KeyBinds.BINDS[action]["shift"] = shift
	KeyBinds.BINDS[action]["control"] = control


func _exit_tree() -> void:
	for bind in BINDS:
		Config.set_value("INPUT_MAP", bind, BINDS[bind])
