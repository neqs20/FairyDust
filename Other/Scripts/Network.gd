extends Node


var authentication = false;


func _ready():
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed",self,"_connection_failed")
	get_tree().connect("server_disconnected",self,"_server_disconnected")
	Network.connect_to_server("192.168.100.104", 4221)

func connect_to_server(IP:String, PORT:int):
	var network = NetworkedMultiplayerENet.new()
	var error = network.create_client(IP, PORT)
	match(error):
		OK:
			print("OK")
		_:
			print("error network!!")
	print("Status: ",network.get_connection_status())
	get_tree().set_network_peer(network)


func _network_peer_connected(id):
	print("Player of ",id," has connected")


func _network_peer_disconnected(id):
	print("Player of ",id," has disconnected")


func _connected_to_server():
	print("Connected to server")


func _connection_failed(error):
	print("Connection Failed")
	print(error)


func _server_disconnected():
	print("Server has disconnected")


func authenticate(login : String, password : String) -> void:
	rpc_id(1,"check_credentials",login,password)
	print("Network: authenticating")


remote func set_authentication(value : bool) -> void:
	print("Network: remote function auth")
	authentication = value