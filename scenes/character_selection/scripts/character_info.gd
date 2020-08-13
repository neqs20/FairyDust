extends MarginContainer


onready var details: RichTextLabel = $Details


const _format := "Level:%d\n\nClass:%s\n\nLoaction:%s"


func update_information(map: int, level: int, classname: int) -> void:
	details.bbcode_text = _format % [level, str(classname), str(map)]
