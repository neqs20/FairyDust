tool
extends TextureButton

var label = Label.new()

export(String) var label_name setget set_label_name


func _ready():
	connect("button_down", self, "_on_enter_button_down")
	connect("button_up", self, "_on_enter_button_up")
	if not has_node("text"):
		label.set_name("text")
		label.set_text(label_name)
		label.set_size(get_size())
		label.valign = Label.VALIGN_CENTER
		label.align = Label.ALIGN_CENTER
		add_child(label, true)
	
func _on_enter_button_up():
	$text.set_position(Vector2(0,0))

func _on_enter_button_down():
	$text.set_position(Vector2(1,1))

func _exit_tree():
	label.free()

func set_label_name(val):
	label_name = val
	label.set_text(label_name)

