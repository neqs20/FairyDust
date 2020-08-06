extends Node

signal authentication(result)
signal characters_data(map, level, classname, name)

const SIGNALS := {
	"connected_to_server" : "connected",
	"connection_failed" : "failed",
	"server_disconnected" : "disconnected",
	"server_packet" : "on_server_packet",
}
const APPLICATION_ID := 698985862419054602

var port: int
var ip: String

var start := 0
var latency := 0 # measured in ms
var connected := false
var is_logged_in := false

var id := -1

var state

var _client := ENetNode.new()
var _client_peer := ENetPacketPeer.new()
var discord := DiscordGameSDK.new()


func _enter_tree() -> void:
	ip = Config.get_ip()
	port = Config.get_port()

	create_client()
	pause_mode = Node.PAUSE_MODE_PROCESS

	var dis_error = discord.create(APPLICATION_ID, DiscordGameSDK.NO_REQUIRE_DISCORD)
	if not dis_error == OK:
		Logger.error(Errors.CANT_CREATE_DISCORD_HOOK, [dis_error])
	discord.set_activity_large_image("fairy_dust_icon")

	add_child(discord)

func on_server_packet(channel: int, raw_packet: PoolByteArray) -> void:
	latency = int((OS.get_ticks_usec() - start) / 1000.0)

	var packet = raw_packet.get_string_from_utf8()
	if packet.length() < Packet.LENGTH: 
		return

	match packet.lcut(Packet.LENGTH):
		Packet.LOGIN:
			if not packet.length() == 1:
				return
			#emit_signal("authentication", get_int(packet.lcut(1)))
			var result = get_int(packet.lcut(1))
			if result == 1:
				Logger.info(Errors.FAILED_LOGIN_ATTEMPT)
				Utils.pop_up("Info!", Errors.WRONG_USERNAME_OR_PASSWORD)
			elif result == 0:
				is_logged_in = true
				SceneChanger.change("res://scenes/character_selection/character_selection.tscn", self, "basic_char_data_received")
		Packet.BASIC_CHAR_DATA:
			var data = {}
			if packet.length() > 5:
				data["map"] = get_int(packet.lcut(2))
				data["level"] = get_int(packet.lcut(2))
				data["class"] = get_int(packet.lcut(1))
				data["name"] = packet
			emit_signal("basic_char_data_received", data)
		_:
			Logger.info("Unhandled packet type. Data: {0}", [packet])


func send_tcp(packet: PoolByteArray, channel := 0) -> void:
	if not connected:
		return

	start = OS.get_ticks_usec()

	_client.send(1, packet, channel)


func send_udp(packet: PoolByteArray, channel := 0) -> void:
	if not connected:
		return

	start = OS.get_ticks_usec()

	_client.send_unreliable(1, packet, channel)


func connected() -> void:
	connected = true
	Logger.info("Connected to the server")


func failed() -> void:
	reset_client()


func disconnected() -> void:
	reset_client()


func reset_client() -> void:
	connected = false
	is_logged_in = false
	id = -1


func set_state(line: String) -> void:
	discord.set_activity_state(line)


func set_details(line: String) -> void:
	discord.set_activity_details(line)


func _exit_tree() -> void:
	Config.set_ip(ip)
	Config.set_port(port)

func create_client() -> void:
	var error = _client_peer.create_client(ip, port, 2)
	if not error == OK:
		Logger.error(Errors.CANT_CREATE_CLIENT)

	_client.set_network_peer(_client_peer)
	_client.poll_mode = ENetNode.MODE_PHYSICS
	_client.signal_mode = ENetNode.MODE_PHYSICS

	id = _client.get_network_unique_id()
	
	for signal_name in SIGNALS:
		if not _client.is_connected(signal_name, self, SIGNALS[signal_name]):
			var connect_error = _client.connect(signal_name, self, SIGNALS[signal_name])
			if not connect_error == OK:
				Logger.error(Errors.CANT_CONNECT_SIGNAL, [self, signal_name, SIGNALS[signal_name], connect_error])
	
	add_child(_client)
