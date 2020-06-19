extends Node

var dialog : AcceptDialog = AcceptDialog.new()

func pop_up(title : String, message : String, size := Vector2(200, 100), node : Node = null, callback := "") -> void:
	dialog.window_title = title
	dialog.dialog_text = message
	dialog.popup_exclusive = true
	dialog.pause_mode = Node.PAUSE_MODE_PROCESS
	if node == null or callback.empty():
		if not dialog.is_connected("confirmed", self, "on_info_dialog_confirmed"):
			dialog.connect("confirmed", self, "on_info_dialog_confirmed")
		if get_children().find(dialog) == -1:
			add_child(dialog)
	else:
		if node.has_method(callback):
			if not dialog.is_connected("confirmed", node, callback):
				dialog.connect("confirmed", node, callback)
			if node.get_children().find(dialog) == -1:
				node.add_child(dialog)
	Logger.info(message)
	get_tree().set_pause(true)
	dialog.popup_centered(size)

func on_info_dialog_confirmed():
	get_tree().set_pause(false)

func _exit_tree():
	dialog.free()
