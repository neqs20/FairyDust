extends Node


const SIGNALS := {
	"connected_to_server" : "connected",
	"connection_failed" : "failed",
	"server_disconnected" : "disconnected",
}
const FUNC := "on_peer_packet"

var port : int
var ip : String
var id := -1
var start := 0
var latency := 0 # measured in ms
var connected := false
var is_logged_in := false

var _client := NetworkedMultiplayerENet.new()
var _discord := DiscordSDK.new()


func _enter_tree() -> void:
	ip = Config.get_ip()
	port = Config.get_port()
	_client.create_client(ip, port)

	id = _client.get_unique_id()

	pause_mode = Node.PAUSE_MODE_PROCESS
	
	get_tree().set_network_peer(_client)

	for signal_name in SIGNALS:
		if not get_tree().is_connected(signal_name, self , SIGNALS[signal_name]):
			get_tree().connect(signal_name, self, SIGNALS[signal_name])

	_discord.create(698985862419054602, DiscordSDK.NO_REQUIRE_DISCORD)
	_discord.set_large_image("fairy_dust_icon")
	add_child(_discord)

remote func on_server_packet(packet: String) -> void:
	latency = int((OS.get_ticks_usec() - start) / 1000.0)

	if packet.length() < Packet.LENGTH: return
	
	match packet.lcut(Packet.LENGTH):
		Packet.LOGIN:
			if packet.length() > 1:
				try_change_scene(get_int(packet.lcut(16)) == -1)
		Packet.BASIC_CHAR_DATA:
			if packet.length() > 5: # TODO: Change to match
				process_char_data(get_int(packet.lcut(2)), get_int(packet.lcut(2)), get_int(packet.lcut(1)), packet)
			elif packet.length() == 0:
				get_tree().current_scene.load_data()
				SceneChanger.fade_out()
		Packet.PLAYER_SPAWN:
			var location_x = get_float(packet.lcut(16))
			var location_y = get_float(packet.lcut(16))
			var location_z = get_float(packet.lcut(16))
			var p_class = get_int(packet.lcut(1))
			
			var name = packet


func send(packet: String) -> void:
	start = OS.get_ticks_usec()

	rpc_id(1, FUNC, id, packet)


func connected() -> void:
	connected = true


func failed() -> void:
	reset_client()


func disconnected() -> void:
	reset_client()


func reset_client() -> void:
	connected = false
	is_logged_in = false
	id = -1


func try_change_scene(value: bool) -> void:
	if value:
		Logger.info(Errors.FAILED_LOGIN_ATTEMPT)
		Utils.pop_up("Info!", Errors.WRONG_USERNAME_OR_PASSWORD)
		return

	is_logged_in = true

	SceneChanger.fade_in_and_change(SceneChanger.scenes["CharacterSelection"])


func process_char_data(map: int, level: int, class_: int, name: String) -> void:
	if get_tree().current_scene.name == "CharacterSelection" and connected:
		get_tree().current_scene.character_data.push_back({
				"map" : map,
				"level" : level,
				"class" : class_,
				"name" : name,
		})


func set_state(line: String) -> void:
	_discord.set_state(line)
	_discord.update_activity()


func set_details(line: String) -> void:
	_discord.set_details(line)
	_discord.update_activity()


func _exit_tree() -> void:
	Config.set_ip(ip)
	Config.set_port(port)
	_discord.queue_free()
