# Server.gd
extends Node

const DEF_PORT = 8080
const PROTO_NAME = "ludus"
var peer := WebSocketMultiplayerPeer.new()
var players := {}
var player_order := []
var server_certs_path = "res://cert/localhost.crt"
var server_key_path = "res://cert/localhost.key"
var game_name := ''
var sessions := {}

@onready var game_io = preload("res://logic/server_game_io.gd").new()

signal session_ended
signal game_started

func _init() -> void:
	peer.supported_protocols = [PROTO_NAME]

func _ready():
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	game_io.name = game_name
	add_child(game_io, true) 

# Starts the server
func start_server():
	var server_certs_file = X509Certificate.new()
	server_certs_file.load(server_certs_path)
	var server_key_file = CryptoKey.new()
	server_key_file.load(server_key_path, false)

	if server_certs_file and server_key_file:
		var tls_options = TLSOptions.server(server_key_file, server_certs_file)
		var err = peer.create_server(DEF_PORT, '*', tls_options)
		if err != OK:
			print("Can't host, address in use.")
			return
	else:
		print("Could not load certificate or key files.")
		return

	multiplayer.multiplayer_peer = peer
	print("Server started on port %s" % DEF_PORT)

# Handles new player connection
func _player_connected(connected_player_id):
	print("Player connected: ", connected_player_id)

# Called when two players join, creating a new session
func create_game_session(peer1_id, peer2_id):
	print("creating sessions %s, %s" % [peer1_id, peer2_id])
	sessions[peer1_id] = peer2_id
	sessions[peer2_id] = peer1_id

	# Start the game for both players
	rpc_id.call_deferred(peer1_id, "start_game", peer1_id)
	rpc_id.call_deferred(peer2_id, "start_game", peer1_id)

func look_up_sessions(id):
	# fucntion ised by the serer_game_io to navigate 
	# rpc calls
	var ids = [id, sessions[id]]
	return ids


# RPC functions. All functions must exist on server and client

@rpc
func start_game(starting_player) -> void:
	# client side function
	pass

@rpc
func _end_game(with_error = "") -> void:
	# client side function 
	pass

@rpc("any_peer")
func receive_username(username) -> void:
	# called by cleant on successful connection to server 
	players[multiplayer.get_remote_sender_id()] = username
	player_order.append(multiplayer.get_remote_sender_id())
	print("Players: %s" % players)
	print("Num players: %s" % len(players))
	if players.size() == 2:
		create_game_session(player_order[0], player_order[1])
		players = {}
		player_order = []

@rpc("any_peer")
func _player_disconnected(player_id):
	print("Player disconnected: ", player_id)
	# end game for other player
	if sessions.has(player_id):
		print("stoppig session for other player")
		var other_player_id = sessions[player_id]
		sessions.erase(player_id)
		sessions.erase(other_player_id)
		rpc_id(other_player_id, "_end_game", "Client disconnected")
	else: 
		print("session already deleted")

	print("open sessions")
	print(sessions)

