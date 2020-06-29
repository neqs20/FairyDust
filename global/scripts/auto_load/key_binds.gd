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
}


func _ready() -> void:
	for action in Config.get_input_map_section_keys():
		if not BINDS.has(action):
			continue
		BINDS[action] = Config.get_value("INPUT_MAP", action, BINDS[action])

	for bind in BINDS:
		InputMap.add_action(bind)

		var input = InputEventKey.new()
		if BINDS[bind].has("alt"):
			if typeof(BINDS[bind].alt) == TYPE_BOOL:
				input.alt = BINDS[bind].alt
		if BINDS[bind].has("shift"):
			if typeof(BINDS[bind].shift) == TYPE_BOOL:
				input.shift = BINDS[bind].shift
		if BINDS[bind].has("control"):
			if typeof(BINDS[bind].control) == TYPE_BOOL:
				input.control = BINDS[bind].control
		if BINDS[bind].has("scancode"):
			if typeof(BINDS[bind].scancode) == TYPE_INT:
				input.scancode = BINDS[bind].scancode
		input.pressed = true
		InputMap.action_add_event(bind, input)

func create_key_binds_buttons() -> Array:
	var ret := []

	for bind in BINDS:
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


func _exit_tree() -> void:
	for bind in BINDS:
		Config.set_value("INPUT_MAP", bind, BINDS[bind])
