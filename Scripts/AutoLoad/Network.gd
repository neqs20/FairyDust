extends Node

var client_peer = ENetPacketPeer.new()
var client = ENetNode.new()

enum PacketType { AUTH, POSITION, CHAT, LATENCY }
enum ChatType { GLOBAL, MAP, AREA, WHISPER, GROUP, YELL }

func _init():
	client.connect("server_disconnected", self, "disconnected")
	client.connect("connection_failed", self, "connect_failed")
	client.connect("connected_to_server", self, "connected")
	client.connect("server_packet", self, "on_server_packet")
	client.connect("peer_packet", self, "on_peer_packet")
	
	client.connect("network_peer_connected", self, "peer_connect")
	client.connect("network_peer_disconnected", self, "peer_disconnect")
	
	client.poll_mode = ENetNode.MODE_PHYSICS
	client.signal_mode = ENetNode.MODE_PHYSICS

	client_peer.create_client("192.168.100.100", 4666, 16)
	client.set_network_peer(client_peer)

	set_physics_process(true)
	set_process(true)
	

func disconnected():
	#kick to login screen with error popup server disconnected (is this triggered when client's net connection dies too?)
	pass


func connect_failed():
	
	pass

func connected():
	pass


func on_server_packet(packet, channel):
	pass


func on_peer_packet(peer, packet, channel):
	pass


func peer_connect(id):
	pass


func peer_disconnect(id):
	pass


func login(username : String, password : String):
	client.send_ordered(1, (hex(PacketType.AUTH, 2) + hex(username.length(), 2) + username + password).to_utf8(), 1)

