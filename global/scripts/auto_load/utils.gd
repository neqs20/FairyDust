extends Node


var _dialog : AcceptDialog = AcceptDialog.new()


func pop_up(title: String, message: String, size := Vector2(200, 100), node: Node = null, callback := "") -> void:
	_dialog.window_title = title
	_dialog.dialog_text = message
	_dialog.popup_exclusive = true
	_dialog.pause_mode = Node.PAUSE_MODE_PROCESS

	if node == null or callback.empty():
		if not _dialog.is_connected("confirmed", self, "on_info_dialog_confirmed"):
			_dialog.connect("confirmed", self, "on_info_dialog_confirmed")
		if get_children().find(_dialog) == -1:
			add_child(_dialog)
	else:
		if node.has_method(callback):
			if not _dialog.is_connected("confirmed", node, callback):
				_dialog.connect("confirmed", node, callback)
			if node.get_children().find(_dialog) == -1:
				node.add_child(_dialog)

	get_tree().set_pause(true)

	_dialog.popup_centered(size)


func on_info_dialog_confirmed():
	get_tree().set_pause(false)


func _exit_tree():
	_dialog.free()
