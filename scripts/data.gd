extends Node


var _CLASS_FULL_NAME = { 
	"Ninja" : "preload",
	"Mage" : "", 
	"Priest" : "", 
	"Puppeter" : "", 
	"Warrior" : "", 
}

var _map_full_name = [ "Tadderia", "Unknown" ]


func get_class_name_by_index(index: int) -> String:
	if index < 0 or index > _CLASS_FULL_NAME.size():
		return ""

	return _CLASS_FULL_NAME.keys()[index]


func get_class_model_by_name(name: String) -> Node:
	if not _CLASS_FULL_NAME.has(name):
		return null

	return _CLASS_FULL_NAME[name]


func get_class_model_by_index(index: int) -> Node:
	return get_class_model_by_name(get_class_name_by_index(index))


func get_map_by_index(index: int) -> String:
	if index < 0 or index > _map_full_name.size():
		return ""

	return _map_full_name[index]
