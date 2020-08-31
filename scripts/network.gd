## Network
## @desc:
##     Handles incoming server packets in callback fashion. Sends packets to the server.
extends Node

## [param result] is a 4-bit signed integer that is either 1 or 0 (hex: 0-f)
## Note that Godot only supports 64 bit signed integers
signal log_in(result)
## [param map] is a 8-bit unsigned integer (hex: 00-ff)
## [param level] is a 8-bit unsigned integer (hex: 00-ff)
## [param class_type] is a 4-bit unsigned integer (hex: 0-f)
## [param charname] is a String
signal characters_data(map, level, class_type, charname)
## [param chat_type] is a one of constants from chat.gd
## [param text] is the message sent
signal text_message(chat_type, text)

enum State {
	NONE,
	CONNECTED,
	LOGGED_IN,
	READY_TO_PLAY,
	IN_GAME,
	MAX,
}

var port: int
var ip: String

## Helper variable that stores the time in which packet was sent
var start := 0
## Network delay measured in milliseconds
var latency := 0

var id := -1

## Represents current state of the client. This is used to prevent some
## unwanted actions (e.g. client should never receive login packets if is already in game)
var state: int = State.NONE

var _client := ENetNode.new()
var _client_peer := ENetPacketPeer.new()
var discord := DiscordGameSDK.new()


func _enter_tree() -> void:
	ip = Config.get_ip()
	port = Config.get_port()

	_create_client()

	_initialize_discord_game_sdk()

	pause_mode = Node.PAUSE_MODE_PROCESS


## Called when a packet is received from the server
func on_server_packet(_channel: int, raw_packet: PoolByteArray) -> void:
	latency = int((OS.get_ticks_usec() - start) / 1000.0)

	var packet = raw_packet.get_string_from_utf8()
	if packet.length() < Packet.LENGTH: 
		return
	match packet.lcut(Packet.LENGTH):
		Packet.LOGIN:
			if not packet.length() == 1:
				return
			emit_signal("log_in", get_int(packet.lcut(1)))
		Packet.BASIC_CHAR_DATA:
			if packet.length() == 0:
				emit_signal("characters_data", 0, 0, 0, "")
			elif packet.length() > 5:
				emit_signal("characters_data", get_int(packet.lcut(2)), 
						get_int(packet.lcut(2)), get_int(packet.lcut(1)), packet)
		Packet.TEXT_CHAT:
			if packet.length() < 2:
				return
			emit_signal("text_message", packet.lcut(1), packet)
		_:
			Logger.info("Unhandled packet type. Data: {0}", [packet])


func send_tcp(packet: PoolByteArray, channel := 0) -> void:
	if state < State.CONNECTED:
		return

	start = OS.get_ticks_usec()

	_client.send(1, packet, channel)


func send_udp(packet: PoolByteArray, channel := 0) -> void:
	if state < State.CONNECTED:
		return

	start = OS.get_ticks_usec()

	_client.send_unreliable(1, packet, channel)


func connected() -> void:
	state = State.CONNECTED
	Logger.info("Connected to the server")


func failed() -> void:
	reset_client()


func disconnected() -> void:
	reset_client()


func reset_client() -> void:
	state = State.NONE
	id = -1


func set_state(line: String) -> void:
	discord.set_activity_state(line)


func set_details(line: String) -> void:
	discord.set_activity_details(line)


func _exit_tree() -> void:
	Config.set_ip(ip)
	Config.set_port(port)


## Sets up network and connects necessary signals
func _create_client() -> void:
	var error = _client_peer.create_client(ip, port)
	if not error == OK:
		Logger.error(Messages.CANT_CREATE_CLIENT)

	_client.set_network_peer(_client_peer)
	_client.poll_mode = ENetNode.MODE_PHYSICS
	_client.signal_mode = ENetNode.MODE_PHYSICS

	id = _client.get_network_unique_id()

	_connect_signals({
		"connected_to_server": "connected",
		"connection_failed": "failed",
		"server_disconnected": "disconnected",
		"server_packet": "on_server_packet",
	})

	add_child(_client)


## Helper function that connects signals
## Keys are signals, values are functions
func _connect_signals(signals: Dictionary) -> void:
	for signal_name in signals:
		if _client.is_connected(signal_name, self, signals[signal_name]):
			return

		var error = _client.connect(signal_name, self, signals[signal_name])

		if error == OK:
			return

		Logger.error(Messages.CANT_CONNECT_SIGNAL, [self, signal_name, signals[signal_name], error])


## Creates [DiscordGameSDK] instance, sets default image for Rich Presence
func _initialize_discord_game_sdk() -> void:
	var error = discord.create(698985862419054602, DiscordGameSDK.NO_REQUIRE_DISCORD)
	if not error == OK:
		Logger.error(Messages.CANT_CREATE_DISCORD_HOOK, [error])
		return
	discord.set_activity_large_image("fairy_dust_icon")
	discord.update_activity()
	add_child(discord)
