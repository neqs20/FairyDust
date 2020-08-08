## Character Selection
extends Control


var character_data = []

onready var list: ItemList = $Info/List
onready var name_val: Label = $Info/Panel/VBoxContainer/NameVal
onready var class_val: Label = $Info/Panel/VBoxContainer/ClassVal
onready var map_val: Label = $Info/Panel/VBoxContainer/MapVal
onready var level_val: Label = $Info/Panel/VBoxContainer/LevelVal


func _ready() -> void:
	Network.set_state("Choosing the character")
	Network.connect("characters_data", self, "_characters_data")


func _characters_data(map: int, level: int, classname: int, charname: String) -> void:
	if charname.empty():
		return
	#character_data.push_back(data)
	#list.add_item(data['name'])
	pass


func _on_List_item_selected(index: int) -> void:
	#name_val.text = character_data[index]["name"]
	#class_val.text = Data.get_class_name_by_index(character_data[index]["class"])
	#map_val.text = Data.get_map_by_index(character_data[index]["map"])
	#level_val.text = str(character_data[index]["level"])
	pass


func _on_Button_pressed() -> void:
	if list.is_anything_selected():
		SceneChanger.change_to("res://World/Tadderia/Tadderia.tscn")
