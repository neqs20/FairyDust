extends VBoxContainer


onready var generator: Generator = $Bottom/Scroll/Container


func _ready() -> void:
	Network.connect("characters_data", self, "_char_data_received")
	## Tests:
	Network.emit_signal("characters_data", 0, 34, 2, "NeQs")
	Network.emit_signal("characters_data", 1, 90, 1, "HazmatDemon")


func _char_data_received(map: int, level: int, class_type: int, charname: String) -> void:
	generator.run(charname, {"map": map, "level": level, "class": class_type})
