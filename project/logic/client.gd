# Client.gd
extends Node

const DEF_PORT = 8080
const PROTO_NAME = "ludus"
var peer := WebSocketMultiplayerPeer.new()
var server_certs_path = "res://cert/localhost.crt"
var ip_address := "localhost"
var user_name := ""
var game_name := ""


signal connection_successful
signal connection_failed
signal disconnected_from_server
signal hide_ui
signal show_ui
signal back_to_lobby

@onready var Game = preload("res://creepagons.tscn")
var game_instance: Node = null

func _init() -> void:
	peer.supported_protocols = [PROTO_NAME]

func _ready():
	multiplayer.connected_to_server.connect(_connected_ok)
	multiplayer.connection_failed.connect(_connected_fail)
	multiplayer.server_disconnected.connect(_server_disconnected)

# Joins the server
func join_server():
	var server_certs_file = X509Certificate.new()
	server_certs_file.load(server_certs_path)

	if server_certs_file:
		var tls_options: TLSOptions
		if server_certs_path == "res://cert/localhost.crt":
			tls_options = TLSOptions.client_unsafe(server_certs_file)
		else:
			tls_options = TLSOptions.client(server_certs_file)

		var server_endpoint = "wss://" + ip_address + ":" + str(DEF_PORT)
		print("Connecting to server at: ", server_endpoint)
		var err = peer.create_client(server_endpoint, tls_options)
		if err != OK:
			emit_signal("connection_failed")
			return
	else:
		print("Could not load certificate")
		return

	multiplayer.multiplayer_peer = peer

func start_offline_game():
	start_game(-1)

func remove_game():
	if game_instance != null:
		game_instance.queue_free()  
		emit_signal("show_ui")
		game_instance = null
		# we nee to remove the client as well
		emit_signal("back_to_lobby")
		

# Callback when connected to the server
func _connected_ok():
	print("Connected to server!")
	rpc_id(1, "receive_username", user_name)
	emit_signal("connection_successful")

# Callback when the connection to the server fails
func _connected_fail():
	print("Failed to connect to server.")
	emit_signal("connection_failed")
	multiplayer.set_multiplayer_peer(null)

# Callback when the server disconnects
func _server_disconnected():
	print("Disconnected from server.")
	emit_signal("disconnected_from_server")
	remove_game()

# RPC functions. All functions must exist on server and client

@rpc
func start_game(starting_player) -> void:
	emit_signal("hide_ui")
	game_instance = Game.instantiate()
	game_instance.game_finished.connect(_end_game)
	game_instance.name = game_name
	add_child(game_instance, true)
	game_instance.set_starting_player(starting_player)

@rpc
func _end_game(with_error = "") -> void:
	emit_signal("disconnected_from_server")
	print("Ending game: ", with_error)
	remove_game()
	rpc_id(1, "_player_disconnected", multiplayer.get_unique_id())
	multiplayer.set_multiplayer_peer(null)


@rpc
func receive_username(username) -> void:
	# server side function
	pass

@rpc 
func _player_disconnected(player_id):
	# server side function
	pass