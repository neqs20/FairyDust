extends TextureButton

func _ready():
	connect("button_down", self, "_on_enter_button_down")
	connect("button_up", self, "_on_enter_button_up")
	if not has_node("text"):
		var label = Label.new()
		label.set_name("text")
		label.set_text("Default Text")
		label.set_size(get_size())
		label.valign = Label.VALIGN_CENTER
		label.align = Label.ALIGN_CENTER
		add_child(label, true)
	
func _on_enter_button_up():
	$text.set_position(Vector2(0,0))

func _on_enter_button_down():
	$text.set_position(Vector2(1,1))
