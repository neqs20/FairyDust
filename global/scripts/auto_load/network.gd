extends Node


signal basic_char_data_received(data)
signal voice_message_received(data)

const SIGNALS := {
	"connected_to_server" : "connected",
	"connection_failed" : "failed",
	"server_disconnected" : "disconnected",
	"server_packet" : "on_server_packet",
}
const APPLICATION_ID := 698985862419054602

var port: int
var id := -1
var start := 0
var latency := 0 # measured in ms
var connected := false
var is_logged_in := false
var ip: String
var player_name: String

var _client := ENetNode.new()
var _client_peer := ENetPacketPeer.new()
var discord := DiscordGameSDK.new()


func _enter_tree() -> void:
	ip = Config.get_ip()
	port = Config.get_port()

	_client_peer.create_client(ip, port, 2)

	_client.set_network_peer(_client_peer)
	_client.poll_mode = ENetNode.MODE_PHYSICS
	_client.signal_mode = ENetNode.MODE_PHYSICS

	id = _client.get_network_unique_id()
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	

	for signal_name in SIGNALS:
		if not _client.is_connected(signal_name, self, SIGNALS[signal_name]):
			_client.connect(signal_name, self, SIGNALS[signal_name])
	
	add_child(_client)
	
	add_child(discord)
	discord.create(APPLICATION_ID, DiscordGameSDK.NO_REQUIRE_DISCORD)
	discord.set_activity_large_image("fairy_dust_icon")


func on_server_packet(channel: int, raw_packet: PoolByteArray) -> void:
	latency = int((OS.get_ticks_usec() - start) / 1000.0)

	var packet = raw_packet.get_string_from_utf8()

	if packet.length() < Packet.LENGTH: 
		return
	
	match packet.lcut(Packet.LENGTH):
		Packet.LOGIN:
			if packet.length() == 1:
				var result = get_int(packet.lcut(1))
				if result == 1:
					Logger.info(Errors.FAILED_LOGIN_ATTEMPT)
					Utils.pop_up("Info!", Errors.WRONG_USERNAME_OR_PASSWORD)

					return
				elif result == 0:
					is_logged_in = true

					SceneChanger.fade_in_and_change(SceneChanger.scenes["character_selection"])
		Packet.BASIC_CHAR_DATA:
			if packet.length() > 5:
				emit_signal("basic_char_data_received", {
							"map" : get_int(packet.lcut(2)),
							"level" : get_int(packet.lcut(2)),
							"class" : get_int(packet.lcut(1)),
							"name" : packet,
				})
			elif packet.length() == 0:
				get_tree().current_scene.load_data()
				SceneChanger.fade_out()
		Packet.VOICE:
			emit_signal("voice_message_received", raw_packet.subarray(2, raw_packet.size() - 1))
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
	discord.update_activity()


func set_details(line: String) -> void:
	discord.set_activity_details(line)
	discord.update_activity()


func _exit_tree() -> void:
	Config.set_ip(ip)
	Config.set_port(port)
