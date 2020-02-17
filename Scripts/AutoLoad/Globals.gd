extends Node


const maps = { 0 : "Beika", 1 : "Collouseum", 2 : "Actus Vill", 3 : "Apulune" }
const classes = { 0 : "Palladin", 1 : "Druid", 2 : "Ranger", 3 : "Puppeter" }

var characters = {}

func get_map_name(index) -> String:
	if maps.has(index):
		return maps[index]
	else:
		return maps[0]

func get_class_name(index) -> String:
	if classes.has(index):
		return classes[index]
	else:
		return classes[0]


func get_character(index : int):
	if characters.has(index):
		return characters[index]
	else:
		null
