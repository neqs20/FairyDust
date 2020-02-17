tool
extends ItemList

onready var labels = get_tree().get_nodes_in_group("description_labels")

var hidden_text = preload("res://Assets/2D/hidden_icon.png")


func _ready():
	for ch in Globals.characters.values():
		add_item(ch["name"], hidden_text)

func _on_ItemList_item_selected(index):
	for label in labels:
		label.set_text(str(Globals.characters[index][label.get_parent().get_name()]))
		
