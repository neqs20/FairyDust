## Login Window Manager
extends Node

## The minimum length of login and password required to send credential data
const MINIMUM_LENGTH := 3

onready var Login: LineEdit = $Login
onready var Password: LineEdit = $Password
onready var EnterButton: Button = $Buttons/Enter
onready var QuitButton: Button = $Buttons/Quit
onready var SaveId: CheckBox = $SaveId


func _ready() -> void:
	SaveId.pressed = Config.get_save_id()

	if SaveId.pressed:
		Login.text = Config.get_username()

	if Login.text.empty():
		Login.grab_focus()
	elif Password.text.empty():
		Password.grab_focus()
	else:
		EnterButton.grab_focus()

	Network.set_state("Login Screen")


## Called when pressed enter on [member Password].
## Triggers [signal Button.pressed]
func _on_Password_text_entered(_new_text: String) -> void:
	EnterButton.emit_signal("pressed")


## Called when text changes for [member Login] or [member Password].
## Toggles [member EnterButton]'s [property Button.disabled] based on the [member Login]'s text length
## and [member Password]'s text length.
## If both [member Login] and [member Password] [property LineEdit.text] [method String.length] is
## grater or equal to [member MINIMUM_LENGTH] then disabled is false
func _on_Login_and_Password_text_changed(_new_text: String) -> void:
	EnterButton.disabled = not (Login.text.length() >= MINIMUM_LENGTH 
			and Password.text.length() >= MINIMUM_LENGTH)


## Called when [member EnterButton] is pressed.
## If connected to server sends credential data
## Otherwise displays PopUp dialog
func _on_Enter_pressed() -> void:
	if Network.connected:
		Network.send_udp((Packet.LOGIN + hex(Login.text.length(), 2) + Login.text 
				+ Password.text.sha256_text()).to_ascii())
	else:
		Utils.pop_up("Connection failed", "You are not connected to the server!")


## Called when [member QuitButton] is pressed
## Requests quit notification (MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
func _on_Quit_pressed() -> void:
	get_tree().quit()


func _exit_tree() -> void:
	if SaveId.pressed:
		Config.set_username(Login.text)
	Config.set_save_id(SaveId.pressed)

	if Network.is_logged_in:
		Network.send_udp(Packet.BASIC_CHAR_DATA.to_ascii())
