extends Control

onready var list = $Info/List
onready var name_val = $Info/Panel/VBoxContainer/NameVal
onready var class_val = $Info/Panel/VBoxContainer/ClassVal
onready var map_val = $Info/Panel/VBoxContainer/MapVal
onready var level_val = $Info/Panel/VBoxContainer/LevelVal

var character_data = []

func _ready() -> void:
	Network.set_state("CharacterSelection")

func load_data() -> void:
	for i in character_data:
		list.add_item(i["name"])

func _on_List_item_selected(index : int) -> void:
	name_val.text = character_data[index]["name"]
	class_val.text = Data.get_class_name_by_index(character_data[index]["class"])
	map_val.text = Data.get_map_by_index(character_data[index]["map"])
	level_val.text = str(character_data[index]["level"])

func _on_Button_pressed() -> void:
	if list.is_anything_selected():
		SceneChanger.change_to("res://World/Tadderia/Tadderia.tscn")
