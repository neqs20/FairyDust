## Scene Changer
extends CanvasLayer


onready var animation = $Animation

## Changes the scene to [param path] with fade effect.
## If [param node] is not null and [param sig] exists waits for [param sig]
## before fading out
func fade(path: String = "", node: Node = null, sig: String = "") -> void:
	animation.play("fade_effect")
	yield(animation, "animation_finished")
	
	if not path.empty():
		var error = get_tree().change_scene(path)
		if error != OK:
			Logger.error(Messages.CANT_CHANGE_SCENE, [error])
	if not (node == null or sig.empty()):
		if node.has_signal(sig):
			yield(node, sig)
	animation.play_backwards("fade_effect")
	yield(animation, "animation_finished")
