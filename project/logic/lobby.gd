# Lobby.gd
extends Control

const PEERNAME := 'Peer' # used by client and server to ensure they have the same name in the node path
const GAMENAME := 'Game'

@onready var host_button = $LobbyPanel/HostButton
@onready var join_button = $LobbyPanel/JoinButton
@onready var offline_button = $LobbyPanel/OfflineButton
@onready var status_ok = $LobbyPanel/StatusOk
@onready var status_fail = $LobbyPanel/StatusFail
@onready var user_name_label = $LobbyPanel/UsernNameLabel
@onready var lobby_ui = $LobbyPanel

@onready var server = preload("res://logic/server.gd").new()
@onready var client = preload("res://logic/client.gd").new()

var args := {}  # command line args
var is_local: bool 

func _ready() -> void:
	parse_cli()
	var stdout = []
	var exit_code = OS.execute("python", ["ai/cli.py", "--hello_arg='thore'"], stdout)
	print(stdout)
	print(exit_code)
	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)
	offline_button.pressed.connect(_on_offline_button_pressed)
	connect_client_signals()
	connect_server_signals()

	if is_local:
		print("running locally")
	else:
		print("running in prod")
		# Running in exported mode, use production IP
		client.ip_address = "creepagonsserver.buecking.me	"
		# if client, we need to locally load the certificate
		client.server_key_path = "res://cert/fullchain1.pem"

	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		print("using server's certificates")
		if not is_local:
			server.server_certs_path = "/etc/letsencrypt/live/creepagonsserver.buecking.me/fullchain.pem"
			server.server_key_path = "/etc/letsencrypt/live/creepagonsserver.buecking.me/privkey.pem"
		_on_host_button_pressed.call_deferred()

func parse_cli() -> void:
	for arg in OS.get_cmdline_args():
		if arg.contains("="):
			var key_value = arg.split("=")
			args[key_value[0].trim_prefix("--")] = key_value[1]
		else:
			# Options without an argument will be present in the dictionary,
			# with the value set to an empty string.
			args[arg.trim_prefix("--")] = ""

	if args.has('local') or OS.has_feature("editor"):
		is_local = true



func connect_server_signals() -> void:
	server.game_started.connect(_on_game_started)
	server.session_ended.connect(_on_session_ended)

func connect_client_signals() -> void:
	client.connection_successful.connect(_on_connected_ok)
	client.connection_failed.connect(_on_connected_fail)
	client.disconnected_from_server.connect(_on_server_disconnected)
	client.hide_ui.connect(hide_ui)
	client.show_ui.connect(show_ui)
	client.back_to_lobby.connect(remove_client)

func hide_ui():
	lobby_ui.hide()

func show_ui():
	lobby_ui.show()

func _on_host_button_pressed():
	print("Hosting server...")
	print(server.name)
	server.name = PEERNAME
	server.game_name = GAMENAME
	add_child(server, true)
	server.start_server()
	_set_status("Hosting server...", true)
	host_button.set_disabled(true)
	join_button.set_disabled(true)

func _on_join_button_pressed():
	print("Joining server...")
	client.user_name = user_name_label.text
	client.name = PEERNAME
	client.game_name = GAMENAME
	add_child(client, true)
	client.join_server()
	_set_status("Joining server...", true)
	host_button.set_disabled(true)
	join_button.set_disabled(true)

func _on_offline_button_pressed():
	print("Starting offline game...")
	add_child(client)
	client.start_offline_game()
	host_button.set_disabled(true)
	join_button.set_disabled(true)

func remove_client():
	if client and client.get_parent():  # Ensure the client exists and is part of the tree
		client.queue_free()  # Remove the client from the scene tree
		client = preload("res://logic/client.gd").new() # Reset the client instance
		connect_client_signals()
		host_button.set_disabled(false)  # Re-enable buttons when back in the lobby
		join_button.set_disabled(false)

func _on_connected_ok():
	_set_status("Connected to server!", true)

func _on_connected_fail():
	_set_status("Couldn't connect.", false)
	host_button.set_disabled(false)
	join_button.set_disabled(false)

func _on_server_disconnected():
	_set_status("Server disconnected.", false)
	host_button.set_disabled(false)
	join_button.set_disabled(false)

func _on_game_started(starting_player):
	# Transition to game scene
	print("Game started. Starting player: ", starting_player)
	# Trigger game start on UI

func _on_session_ended():
	# Handle session end and clean up
	print("Session ended.")
	_set_status("Game session ended.", false)

func _set_status(text, isok):
	if isok:
		status_ok.set_text(text)
		status_fail.set_text("")
	else:
		status_ok.set_text("")
		status_fail.set_text(text)
