extends Node


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
	
	#Network.discord.create_lobby("general-1", 10, DiscordGameSDK.PUBLIC)
	#Network.discord.connect("lobby_created", self, "lobby_created")

func connect_to_voice(lobby_id, secret) -> void:
	Network.discord.connect_to_lobby(lobby_id, secret)
	Network.discord.connect_to_lobby_voice(lobby_id)


func lobby_created(result, lobby_id, owner_id, secret, is_locked) -> void:
	if result == DiscordGameSDK.OK:
		connect_to_voice(lobby_id, secret)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		if SaveId.pressed:
			Config.set_username(Login.text)
		Config.set_save_id(SaveId.pressed)


func _on_Password_text_entered(_new_text: String) -> void:
	EnterButton.emit_signal("pressed")


func _on_Login_and_Password_text_changed(_new_text: String) -> void:
	EnterButton.disabled = not (Login.text.length() >= MINIMUM_LENGTH 
			and Password.text.length() >= MINIMUM_LENGTH)


func _on_Enter_pressed() -> void:
	#if Network.connected:
	#	Network.send_udp((Packet.LOGIN + hex(Login.text.length(), 2) + Login.text 
	#			+ Password.text.sha256_text()).to_ascii())
	#else:
	#	Utils.pop_up("Authentication failed", "You are not connected to the server!")
	pass

func _on_Quit_pressed() -> void:
	get_tree().quit()


func _exit_tree() -> void:
	if Network.is_logged_in:
		Network.send_udp(Packet.BASIC_CHAR_DATA.to_ascii())
