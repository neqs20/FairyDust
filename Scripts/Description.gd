extends Control


func _ready():
	for i in get_tree().get_nodes_in_group("description_labels"):
		i.get_font("font").set_size(30 * (get_viewport().get_size().x / 1920))
