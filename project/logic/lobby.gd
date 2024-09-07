extends Control

const DEF_PORT = 8080
const PROTO_NAME = "ludus"

var peer := WebSocketMultiplayerPeer.new()

@onready var address = $Address
@onready var host_button = $HostButton
@onready var join_button = $JoinButton
@onready var status_ok = $StatusOk
@onready var status_fail = $StatusFail

func _init() -> void:
	peer.supported_protocols = ["ludus"]

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
		_player_connected.call_deferred()

#### Network callbacks from SceneTree ####

# Callback from SceneTree.
func _player_connected(connected_player_id):
	# Someone connected, start the game!
	# Retrieve the server's network ID.
	var server_id = multiplayer.get_unique_id()
	# Create a list of the player IDs (server and connected player).
	var player_ids = [server_id, connected_player_id]
	var game = load("res://creepagons.tscn").instantiate()
	# Connect deferred so we can safely erase it from the callback.
	game.game_finished.connect(_end_game, CONNECT_DEFERRED)
	get_tree().get_root().add_child(game)
	hide()

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
	if has_node("/root/Creepagons"):
		# Erase immediately, otherwise network might show
		# errors (this is why we connected deferred above).
		var creepagons = get_node("/root/Creepagons")
		 # Disconnect signals
		creepagons.game_finished.disconnect(_end_game)
		# Free the instance
		creepagons.queue_free()
		show()

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
	 # Maximum of 1 peer, since it's a 2-player game.
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
	var ip = address.get_text()
	if not ip.is_valid_ip_address():
		_set_status("IP address is invalid.", false)
		return
	var err = peer.create_client("ws://" + str(ip) + ":" + str(DEF_PORT))
	if err != OK:
		_set_status("Can't create client", false)
		return
	
	multiplayer.multiplayer_peer = peer

	_set_status("Connecting...", true)


func _on_offline_button_pressed():
	_player_connected(2)
