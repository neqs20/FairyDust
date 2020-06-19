extends CanvasLayer

onready var animation = $Animation

func change_to(path : String) -> void:
	animation.play("fade_effect")
	yield(animation, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation.play_backwards("fade_effect")
	yield(animation, "animation_finished")


func fade_in_and_change(path : String) -> void:
	animation.play("fade_effect")
	yield(animation, "animation_finished")
	assert(get_tree().change_scene(path) == OK)

func fade_out() -> void:
	animation.play_backwards("fade_effect")
	yield(animation, "animation_finished")

