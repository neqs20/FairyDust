extends Button

onready var login = $"../login_field"
onready var password = $"../password_field"


func _on_Button_pressed() -> void:
	if !login.text.empty() and !password.text.empty():
		Network.authenticate(login.text, password.text)
		if !Network.authentication:
			$warning_dialog.popup_centered(Vector2(250,150))
			get_tree().set_pause(true)
		print("enter_button: button pressed, sending credentials")
	else:
		$warning_dialog.popup_centered(Vector2(250,150))