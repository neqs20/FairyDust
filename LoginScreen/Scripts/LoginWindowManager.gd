extends Node

onready var Login : LineEdit = $Login
onready var Password : LineEdit = $Password
onready var EnterButton : Button = $Buttons/Enter
onready var QuitButton : Button = $Buttons/Quit
onready var SaveId : CheckBox = $SaveId

const _MINIMUM_LENGTH : int = 3

func _ready() -> void:
	SaveId.pressed = Config.get_save_id()
	if SaveId.pressed:
		Login.text = Config.get_username()
		#Login.emit_signal("text_changed", Login.text) #!need
	if Login.text.empty():
		Login.grab_focus()
	elif Password.text.empty():
		Password.grab_focus()
	else:
		EnterButton.grab_focus()
	Network.set_state("LoginScreen")

func _on_Password_text_entered(_new_text) -> void:
	EnterButton.emit_signal("pressed")

func _on_Login_and_Password_text_changed(_new_text) -> void:
	EnterButton.disabled = not (Login.text.length() >= _MINIMUM_LENGTH and Password.text.length() >= _MINIMUM_LENGTH)

func _on_Enter_pressed() -> void:
	Network.send(Packet.LOGIN + hex(Login.text.length(), 2) + Login.text + Password.text.sha256_text());

func _on_Quit_pressed() -> void:
	if SaveId.pressed:
		Config.set_username(Login.text)
	Config.set_save_id(SaveId.pressed)
	get_tree().quit()

func _exit_tree() -> void:
	if Network.is_logged_in:
		Network.send(Packet.BASIC_CHAR_DATA)

