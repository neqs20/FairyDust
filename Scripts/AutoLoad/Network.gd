extends Node

var client_peer = ENetPacketPeer.new()
var client = ENetNode.new()

var connected = false

enum PacketType { AUTH, POSITION, CHAT, LATENCY, CHARACTERS_INFO, CHARACTER_STATS }
enum ChatType { GLOBAL, MAP, AREA, WHISPER, GROUP, YELL }

var latency : int = 0
var start_time : int = 0

var window = AcceptDialog.new()
var characters = {}
var client_error = -1

func _ready():
	setup_client()

func disconnected():
	#kick to login screen with error popup server disconnected (is this triggered when client's net connection dies too?)
	#Log.info("disconnected")
	connected = false


func connect_failed():
	#Log.info("failed")
	connected = false

func connected_to_server():
	#Log.info("connected")
	connected = true


func on_server_packet(_channel, packet):
	packet = packet.get_string_from_utf8()
	match get_int(packet.lcut(2)):
		PacketType.LATENCY:
			latency = (OS.get_ticks_usec() - start_time) / 1000
		PacketType.AUTH:
			var status = get_int(packet.lcut(1))
			if status == 0:
				popup("Error", "Unknown username or password")
			elif status == 1:
				var error = get_tree().change_scene("res://CharacterScreen.tscn")
	#			Log.error("Could not change scene error code: {0}", [error])
			else:
				popup("Error", "Something went wrong. Please contact server administrator!")
		PacketType.CHARACTERS_INFO:
			characters[get_int(packet.lcut(1))] = { "name" : packet.lcut(get_int(packet.lcut(2))), "class" : get_int(packet.lcut(1)), "level" : get_int(packet.lcut(2)), "map" : get_int(packet.lcut(2))}

func peer_connect(_id):
	pass


func peer_disconnect(_id):
	pass


func send_udp(target : int, packet : PoolByteArray, channel : int):
	client.send_unreliable(target, packet, channel)


func send_udp_to_server(packet : PoolByteArray, channel : int):
	start_time = OS.get_ticks_usec()
	send_udp(1, packet, channel)


func send_tcp(target : int, packet : PoolByteArray, channel : int):
	client.send_ordered(target, packet, channel)


func send_tcp_to_server(packet : PoolByteArray, channel : int):
	start_time = OS.get_ticks_usec()
	send_tcp(1, packet, channel)
	

func send(target : int, packet : PoolByteArray, channel : int):
	client.send(target, packet, channel)


func login(username : String, password : String):
	send_udp_to_server((hex(PacketType.AUTH, 2) + hex(username.length(), 2) + username + password).to_utf8(), 1)


func enter_the_game():
	send_udp_to_server((hex(PacketType.CHARACTERS_STATS, 2)).to_utf8(), 1)


func popup(title : String, text : String, size := Vector2(300,150)):
	if not window.is_connected("popup_hide", self, "popup_hide"):
		window.connect("popup_hide", self, "popup_hide")
	window.window_title = title
	window.dialog_text = text
	window.set_exclusive(true)
	window.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	get_tree().get_current_scene().add_child(window)
	get_tree().set_pause(true)
	window.popup_centered(size)
	


func popup_hide():
	get_tree().set_pause(false)
	get_tree().get_current_scene().remove_child(window)


func setup_client():
	if client_error == 0:
		return
	if not client.is_connected("server_disconnected", self, "disconnected"):
		client.connect("server_disconnected", self, "disconnected")
	if not client.is_connected("connection_failed", self, "connect_failed"):
		client.connect("connection_failed", self, "connect_failed")
	if not client.is_connected("connected_to_server", self, "connected_to_server"):
		client.connect("connected_to_server", self, "connected_to_server")
	if not client.is_connected("server_packet", self, "on_server_packet"):
		client.connect("server_packet", self, "on_server_packet")
	if not client.is_connected("network_peer_connected", self, "peer_connect"):
		client.connect("network_peer_connected", self, "peer_connect")
	if not client.is_connected("network_peer_disconnected", self, "peer_disconnect"):
		client.connect("network_peer_disconnected", self, "peer_disconnect")
	
	client.poll_mode = ENetNode.MODE_PHYSICS
	client.signal_mode = ENetNode.MODE_PHYSICS
	
	if client_error == -1:
		client_error = client_peer.create_client("192.168.100.100", 4666, 16)
		client.set_network_peer(client_peer)
		add_child(client)


func _exit_tree():
	client.free()
	window.free()
