class_name Generator
extends VBoxContainer


const button_group: ButtonGroup = preload("res://scenes/character_selection/resources/character_buttons_group.tres")
const font: DynamicFont = preload("res://assets/fonts/ubuntu/normal14.tres")

onready var selection: VBoxContainer = $"../../../"
onready var details: MarginContainer = selection.get_node("Top/Offset")
onready var name_tag: Label = selection.get_node("Top/Name")


func run(text: String, metadata: Dictionary) -> void:
	var button := Button.new()
	button.text = text
	button.toggle_mode = true
	button.group = button_group
	button.rect_min_size.x = 300
	button.rect_min_size.y = 25
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.set("custom_fonts/font", font)
	button.connect("toggled", self, "_character_selected", [button])
	for meta in metadata:
		button.set_meta(meta, metadata[meta])
	add_child(button)


func _character_selected(pressed: bool, button: Button) -> void:
	details.update_information(button.get_meta("map"), button.get_meta("level"),
			button.get_meta("class"))
	name_tag.text = button.text
