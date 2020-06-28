extends CanvasLayer


const scenes : Dictionary = {
	"character_selection" : "res://character_selection/character_selection.tscn"
}

onready var animation = $Animation


func change_to(path: String) -> void:
	animation.play("fade_effect")
	yield(animation, "animation_finished")

	get_tree().change_scene(path)

	animation.play_backwards("fade_effect")
	yield(animation, "animation_finished")


func fade_in_and_change(path: String) -> void:
	animation.play("fade_effect")
	yield(animation, "animation_finished")

	get_tree().change_scene(path)


func fade_out() -> void:
	animation.play_backwards("fade_effect")
	yield(animation, "animation_finished")

