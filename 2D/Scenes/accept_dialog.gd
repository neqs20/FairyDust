extends AcceptDialog

func _ready():
	set_title("Warning!")
	set_text("Wrong username or password")

func _on_warning_dialog_popup_hide():
	get_tree().set_pause(false)
