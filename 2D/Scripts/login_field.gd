extends LineEdit


func _ready():
	if Config.current["save_id"] == true:
		text = Config.current["login_field"]


func _on_login_field_text_changed(new_text):
	Config.update("login_field",text)
