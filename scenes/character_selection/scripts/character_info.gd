extends MarginContainer


onready var details: RichTextLabel = $Details


func update_information(map: int, level: int, classname: int) -> void:
	details.bbcode_text = "Level: %d\n\nClass: %s\n\nLoaction: %s" % [level, str(classname), str(map)]
