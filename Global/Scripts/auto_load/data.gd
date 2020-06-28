extends Node


const _class_full_name = { 
	"Ninja" : "preload",
	"Mage" : "", 
	"Priest" : "", 
	"Puppeter" : "", 
	"Warrior" : "", 
}

var _map_full_name = [ "Tadderia", "Unknown" ]

func get_class_name_by_index(index: int) -> String:
	if index < 0 or index > _class_full_name.size():
		return ""
	return _class_full_name.keys()[index]

func get_class_model_by_name(name: String) -> Node:
	if not _class_full_name.has(name):
		return null
	return _class_full_name[name]

func get_class_model_by_index(index: int) -> Node:
	return get_class_model_by_name(get_class_name_by_index(index))

func get_map_by_index(index: int) -> String:
	if index < 0 or index > _map_full_name.size():
		return ""
	return _map_full_name[index]
