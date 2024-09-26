# Server.gd
extends Node

const DEF_PORT = 8080
const PROTO_NAME = "ludus"
const BOT_ID_BASE := 990000000000
var peer := WebSocketMultiplayerPeer.new()
var peer_internal := WebSocketServer.new()
var players := {}
var player_order := []
var server_certs_path = "res://cert/localhost.crt"
var server_key_path = "res://cert/localhost.key"
var game_name := ''
var sessions := {}
var bot_q = []

@onready var game_io = preload("res://logic/server_game_io.gd").new()
@onready var game_bot = preload("res://logic/server_game_io_ws.gd").new()

signal session_ended
signal game_started

func _init() -> void:
	peer.supported_protocols = [PROTO_NAME]

func _ready():
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	peer_internal.client_connected.connect(_bot_connected)
	peer_internal.client_disconnected.connect(_bot_disconnected)
	peer_internal.message_received.connect(_bot_msg_received)
	game_io.name = game_name
	add_child(game_io, true) 
	add_child(game_bot)

# Starts the server
func start_server():
	var server_certs_file = X509Certificate.new()
	server_certs_file.load(server_certs_path)
	var server_key_file = CryptoKey.new()
	server_key_file.load(server_key_path, false)
	var err
	if server_certs_file and server_key_file:
		var tls_options = TLSOptions.server(server_key_file, server_certs_file)
		err = peer.create_server(DEF_PORT, '*', tls_options)
		if err != OK:
			print("Can't host, address in use.")
			return
	else:
		print("Could not load certificate or key files.")
		return

	multiplayer.multiplayer_peer = peer
	print("Server started on port %s" % DEF_PORT)

	# also set up internal peer for interacing on localhost
	var port = DEF_PORT + 1
	err = peer_internal.listen(port)
	if err != OK:
		print("Error listing on port %s" % (port))
		return
	print("Listing on port %s, supported protocols: %s" % [port, peer_internal.supported_protocols])

func _process(_delta):
	peer_internal._process(_delta)

func _bot_connected(peer_id: int):
	print("bot connected %s" % peer_id)
	bot_q.append(peer_id)
	if bot_q.size() == 2:
		print("creating bot game")
		create_game_session(bot_q[0], bot_q[1], true)
		bot_q = []


func _bot_disconnected(peer_id: int):
	print("bot disconnected %s" % peer_id)
	if sessions.has(peer_id):
		print("stoppig session for other player")
		var session = sessions[peer_id]
		var other_peer_id = session.get_other_peer_id(peer_id)
		session.end_session()
		sessions.erase(peer_id)
		sessions.erase(other_peer_id)
		peer_internal.send(other_peer_id, "end_game")
	else: 
		print("session already deleted")


func _bot_msg_received(peer_id: int, message: String):
	game_bot.receive_msg(peer_id, message)


# Handles new player connection
func _player_connected(connected_player_id):
	print("Player connected: ", connected_player_id)

# Called when two players join, creating a new session
func create_game_session(peer1_id, peer2_id, is_bots: bool):
	print("creating sessions %s, %s" % [peer1_id, peer2_id])
	var session_id = str("session_", randf())
	var session = Session.new(session_id, peer1_id, peer2_id)
	session.is_against_bot = peer2_id > BOT_ID_BASE

	sessions[peer1_id] = session
	sessions[peer2_id] = session 

	if not is_bots:
		# Start the game for both players
		rpc_id.call_deferred(peer1_id, "start_game", peer1_id)
		if not session.is_against_bot:
			rpc_id.call_deferred(peer2_id, "start_game", peer1_id)
	else: 
		game_bot.start(session)

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
func receive_username(username, is_single_player:bool) -> void:
	# called by cleant on successful connection to server 
	if not is_single_player:
		players[multiplayer.get_remote_sender_id()] = username
		player_order.append(multiplayer.get_remote_sender_id())
		print("Players: %s" % players)
		print("Num players: %s" % len(players))
		if players.size() == 2:
			create_game_session(player_order[0], player_order[1], false)
			players = {}
			player_order = []
	else:
		print("starting single player game")
		var player_id = multiplayer.get_remote_sender_id()
		var bot_id = BOT_ID_BASE + player_id
		create_game_session(player_id, bot_id, false)

@rpc("any_peer")
func _player_disconnected(player_id):
	print("Player disconnected: ", player_id)
	# end game for other player
	if sessions.has(player_id):
		print("stoppig session for other player")
		var session = sessions[player_id]
		var other_player_id = session.get_other_peer_id(player_id)
		session.end_session()
		sessions.erase(player_id)
		sessions.erase(other_player_id)
		rpc_id(other_player_id, "_end_game", "Client disconnected")
	else: 
		print("session already deleted")

	print("open sessions")
	print(sessions)

