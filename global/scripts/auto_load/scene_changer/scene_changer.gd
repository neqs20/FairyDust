extends CanvasLayer


const scenes := { #* List of instantiable scenes. Quiet worthless ?
	"character_selection" : "res://character_selection/character_selection.tscn"
}

onready var animation = $Animation


func change_to(path: String) -> void:
	fade_in_and_change(path)

	fade_out()


func fade_in_and_change(path: String) -> void:
	animation.play("fade_effect")
	yield(animation, "animation_finished")

	match get_tree().change_scene(path):
		OK:
			pass
		var err:
			Logger.error(Errors.CANT_CHANGE_SCENE, [err])


func fade_out() -> void:
	animation.play_backwards("fade_effect")
	yield(animation, "animation_finished")

