extends Control

const DEF_PORT = 8080
const PROTO_NAME = "ludus"

var peer := WebSocketMultiplayerPeer.new()
var players := {}
var player_order := []

@onready var host_button = $HostButton
@onready var join_button = $JoinButton
@onready var status_ok = $StatusOk
@onready var status_fail = $StatusFail
@onready var game = get_node("../Creepagons")
@onready var user_name_label = $UsernNameLabel
@onready var _self  = get_node("../LobbyPanel")

@export var ip_address := '34.69.180.97'

func _init() -> void:
	peer.supported_protocols = [PROTO_NAME]

func _ready():
	# Connect all the callbacks related to networking.
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_connected_ok)
	multiplayer.connection_failed.connect(_connected_fail)
	multiplayer.server_disconnected.connect(_server_disconnected)
	# You can save bandwidth by disabling server relay and peer notifications.
	multiplayer.server_relay = false
	# Automatically start the server in headless mode.
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		_on_host_button_pressed.call_deferred()

#### Network callbacks from SceneTree ####

# Callback from SceneTree.
func _player_connected(connected_player_id):
	if not multiplayer.is_server():
		return
	if connected_player_id == -1:
		start_game(1)
	else:
		rpc_id(connected_player_id, "request_user_name")

	print("players: %s" % players)
	print("num players: %s" % len(players))

@rpc("authority", "call_local")
func start_game(starting_player):
	game.show()
	game.set_starting_player(starting_player)
	_self.hide()
	
func _player_disconnected(_id):
	if multiplayer.is_server():
		_end_game("Client disconnected")
	else:
		_end_game("Server disconnected")

# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	pass # This function is not needed for this project.

# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	_set_status("Couldn't connect.", false)

	multiplayer.set_multiplayer_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)


func _server_disconnected():
	_end_game("Server disconnected.")

##### Game creation functions ######

func _end_game(with_error = ""):
	print("here")
	game.queue_free()
	game = preload("res://creepagons.tscn").instantiate()
	game.hide()
	show()
	get_tree().root.add_child(game)

	#multiplayer.set_multiplayer_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)

	_set_status(with_error, false)


func _set_status(text, isok):
	# Simple way to show status.
	if isok:
		status_ok.set_text(text)
		status_fail.set_text("")
	else:
		status_ok.set_text("")
		status_fail.set_text(text)


func _on_host_button_pressed():
	multiplayer.multiplayer_peer = null
	var err = peer.create_server(DEF_PORT)
	multiplayer.multiplayer_peer = peer
	if err != OK:
		# Is another server running?
		_set_status("Can't host, address in use.",false)
		return

	#multiplayer.set_multiplayer_peer(peer)
	host_button.set_disabled(true)
	join_button.set_disabled(true)
	_set_status("Waiting for player...", true)


func _on_join_button_pressed():
	multiplayer.multiplayer_peer = null
	var err = peer.create_client("wss://" + ip_address + ":" + str(DEF_PORT))
	if err != OK:
		_set_status("Can't create client", false)
		return
	
	multiplayer.multiplayer_peer = peer

	_set_status("Connecting...", true)

@rpc("authority")
func request_user_name(): 
	# called by server on client device
	rpc_id(1, "receive_username", user_name_label.text)
	
@rpc("any_peer")
func receive_username(username):
	# called on server side by the client
	print(username)
	print(multiplayer.get_remote_sender_id())
	players[multiplayer.get_remote_sender_id()] = username
	player_order.append(multiplayer.get_remote_sender_id())
	if len(players) == 2:
	# Someone connected, start the game
		rpc("start_game", player_order[0])
	
func _on_offline_button_pressed():
	_player_connected(-1)
