tool
extends Popup

var style := StyleBoxFlat.new()

var background := PanelContainer.new()
var title_bar_background := ColorRect.new()
var title := Label.new()

export(float) var title_bar_height = 20 setget set_title_bar_height
export(Color) var title_bar_color = Color(1, 1, 1) setget set_title_bar_color
export(Vector2) var window_size = Vector2(200, 200) setget set_window_size
export(String, MULTILINE) var title_bar_text = "" setget set_title_bar_text
export(Color) var background_color = Color(0.24, 0.24, 0.27) setget set_background_color

func _enter_tree():
	# important childs, order matters!
	add_child(background, true)
	add_child(title_bar_background, true)
	add_child(title, true)
	
	# background
	# to be added
	
	# child settings
	background.set_size(window_size)
	
	title_bar_background.set_size(Vector2(window_size.x, title_bar_height))
	
	title.set_size(Vector2(window_size.x, title_bar_height))
	title.set_align(Label.ALIGN_CENTER)
	title.set_valign(Label.VALIGN_CENTER)
	
	# signals
	
	
	background.add_stylebox_override("panel",style)
	
func _ready():
	show()

func set_title_bar_height(value):
	title_bar_height = value
	update_title_bar_height(title_bar_height)


func update_title_bar_height(value):
	title.set_size(Vector2(window_size.x, value))
	title_bar_background.set_size(Vector2(window_size.x, value))


func update_title_bar_width(value):
	title.set_size(Vector2(value.x, title_bar_height))
	title_bar_background.set_size(Vector2(value.x, title_bar_height))


func set_title_bar_color(value):
	title_bar_color = value
	title_bar_background.color = title_bar_color


func set_window_size(value):
	window_size = value
	update_title_bar_width(window_size)
	self.set_size(window_size)
	background.set_size(window_size)


func set_title_bar_text(value):
	title_bar_text = value
	title.text = title_bar_text


func set_background_color(value):
	background_color = value
	style.set_bg_color(value)
