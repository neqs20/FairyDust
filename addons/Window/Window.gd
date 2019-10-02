tool
extends Popup

var panel_container := PanelContainer.new()
var color_rect := ColorRect.new()
var label := Label.new()

export(float) var title_height = 20 setget set_title_height

export(Color) var title_color = Color(0,0,0) setget set_title_color


func _enter_tree():
	add_child(panel_container, true)
	
	add_child(label, true)
	color_rect.set_owner(get_tree().get_edited_scene_root())
	add_child(color_rect, true)
	panel_container.set_size(Vector2(400,600))
	label.set_size(Vector2(400,20))
	color_rect.set_size(label.get_size())

func _ready():
	show()

func set_title(title : String):
	label.text = title

func _set_size(new : Vector2):
	panel_container.set_size(new)
	
func set_title_size(val):
	title_height = val
	set_title_height(val.y)
	
func set_title_height(height : float):
	label.set_size(Vector2(panel_container.get_size().x, height))
	color_rect.set_size(label.get_size())
	
func set_title_color(color):
	title_color = color
	color_rect.color = title_color