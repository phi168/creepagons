GDPC                �                                                                      /   T   res://.godot/exported/133200997/export-22792ee0018d439a895e1f6e6e7db267-tile_map.scn e     8      -=���տ��B�>왼�    T   res://.godot/exported/133200997/export-23186f883164cbeaffe487e6aecd5af8-lobby.scn   �>     �      ���������,��    X   res://.godot/exported/133200997/export-2c0b74ff05f65254759fd6e42c74af28-creepagons.scn  �     �      g讗��|̈́�^�'    T   res://.godot/exported/133200997/export-7d2e871219e9bd7bcea6e0a9676cd88c-tutorial.scn`q     ("      2_�S��-�I%�8��    T   res://.godot/exported/133200997/export-8a1bc4a5e065b660eda929a3d643d9f2-simulate.scn0O     �      \=_��mR�o��)���    X   res://.godot/exported/133200997/export-d9e4c8cfe69d689f3f1e0705b64e1057-game_engine.scn �+     x      P��k�e����R���    \   res://.godot/exported/133200997/export-ed741d667641bac3123dedd5ca607399-hex_piece_logic.scn P.           ��j�9����Wz[���    ,   res://.godot/global_script_class_cache.cfg  ��           �Mt�����wqc�R�/W    D   res://.godot/imported/1.png-515c813a180ba5fd2e61c8e75c4cac47.ctex   �G            �4E@�*�a:OQQ�9=    D   res://.godot/imported/2.png-3f238cfe6181f9f93f40cee36336f408.ctex   �c      �      \X<p���H{���t|w    D   res://.godot/imported/3.png-ab9dc1e38b41816b4ae4b69d0cb53034.ctex   �~      v      p���<u���h�\U��    D   res://.godot/imported/4.png-cf0c36ab2aa3a6a557ce983302464362.ctex    �      �      ]M��_b�}x�|l�`.     D   res://.godot/imported/5.png-d8eabfb4819dbc68a3ed4acdc14b975c.ctex   ��      \      ٪���d��[(o    D   res://.godot/imported/6.png-66d5265b13364699fc1651f14737e8e3.ctex   ��      \      ���& �%Y갶�    D   res://.godot/imported/7.png-e72809ab7ccd112ddfd11a481f421ba8.ctex   ��      H      *�J���_S�
    H   res://.godot/imported/arrow.png-9a52328c9c8f79a188b7fabb13b1f3fc.ctex   ��      2.      ʿyV��L�ՏW�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�0           ：Qt�E�cO���    H   res://.godot/imported/tiles.png-20e12ed313f9b52ca4483ea23302e684.ctex   �[     n      ҉���.���&��2�       res://.godot/uid_cache.bin  p�     �      5]T�V��"6���+zAV       res://1.png.import  �b      �       �����=@$�g�k
ha       res://2.png.import   ~      �       S���yZ��;��&��       res://3.png.import  @�      �       2���N;:v�o���       res://4.png.import  ��      �       ���4�G��, ����       res://5.png.import  ��      �       _-}n���K?�B�       res://6.png.import   �      �       �1>����e��	�>q�       res://7.png.import  �      �       #˥`xȤum�E�!�       res://Server.gd �F     �      ?���x��������y       res://arrow.png.import       �       ���㕛�m2k6W-       res://creepagons.tscn.remap ��     g       ��3Ҥ(��X�J����       res://game_engine.tscn.remap �     h       �ߊ}*������/]"xp        res://hex_piece_logic.tscn.remapp�     l       .aB�-�+ΒptK��       res://icon.svg  ��     �      k����X3Y���f       res://icon.svg.import   �=     �       �?���I��֞9       res://lobby.tscn.remap  ��     b       �ې�=3���!��       res://logic/client.gd                 >6` ��6��Qy]�       res://logic/creepagons.gd         �      ���ՅϮv���Ӻ��       res://logic/game_engine.gd  �      �
      $�Ꜻ������{��        res://logic/hex_piece_logic.gd  �            ;�U'-�A3<]l6/�       res://logic/lobby.gd�%            ����W;U�<&k`�       res://logic/simulate.gd �4            O/G��Y�^�i�vQ    $   res://logic/tile_map_controller.gd   ;      [      �)K�JT��K�kTP�        res://logic/tutorial_panel.gd   `F      C      �n�e��ԙ;�=�tQ       res://project.binaryP�     X      Ig��{fiAB��o*E       res://simulate.tscn.remap   P�     e       {��i��$X��C���       res://tile_map.tscn.remap   ��     e       ����/tw*��i���ߖ       res://tiles.png.import  Pd     �       �3�Wa�C%V�:Ud       res://tutorial.tscn.remap   0�     e       ��_��h0@e������`        extends Node

# The URL we will connect to.
@export var websocket_url = "wss://echo.websocket.org"

# Our WebSocketClient instance.
var socket = WebSocketPeer.new()

func _ready():
	# Initiate connection to the given URL.
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		# Wait for the socket to connect.
		await get_tree().create_timer(2).timeout

		# Send data.
		socket.send_text("Test packet")

func _process(_delta):
	# Call this in _process or _physics_process. Data transfer and state updates
	# will only happen when calling this function.
	socket.poll()

	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()

	# WebSocketPeer.STATE_OPEN means the socket is connected and ready
	# to send and receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			print("Got data from server: ", socket.get_packet().get_string_from_utf8())

	# WebSocketPeer.STATE_CLOSING means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# WebSocketPeer.STATE_CLOSED means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be -1 if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.
extends Node2D

signal game_finished()

const max_num_moves := 2
# Player state variables
var current_player_id: int
var player_ids: Array = [1, 2]
var my_player_id: int
var is_online: bool = false
var moves_remaining: int = max_num_moves

# Reference to the nodes
@onready var tile_map = $GameBoard
@onready var game_engine = $GameEngine
@onready var current_player_label = $CurrentPlayer
@onready var my_player_label = $MyPlayerId
@onready var tiles_occupied_label = $TilesOccupied
@onready var winner_label = $Winner
@onready var adjacney_label = $AdjcencyLabel
@onready var moves_left_label = $MovesLeftLabel
@onready var points_label = $PointsLabel


func _ready() -> void:
	is_online = len(multiplayer.get_peers()) > 0
	var width = tile_map.get_used_rect().size.x
	var height = tile_map.get_used_rect().size.y
	tile_map.init_text(height, width)
	game_engine.get_base_deltas()
	adjacney_label.text = "Adjacency rules: %s" % game_engine.adj_delta_rules
	tile_map.render_game_state(game_engine.grid)
	current_player_id = 1
	current_player_label.text = "White's turn"
	if multiplayer.is_server() or not is_online:
		my_player_id = 1
		my_player_label.text = "playing as white."
	else:
		my_player_id = 2
		my_player_label.text = "playing as black."
		
# advance turn
@rpc("any_peer", "call_local")
func next_turn():
	# apply changes of cell ownership / hp
	game_engine.update_game_state()
	# calculate the next prospective deltas
	game_engine.get_base_deltas()
	# render the new state
	tile_map.render_game_state(game_engine.grid)
	points_label.text = "points: %s/%s (w/b)" % [game_engine.num_tiles_p1, game_engine.num_tiles_p2]
	tiles_occupied_label.text = "tiles occupied: %s/%s" % [game_engine.num_occupied_tiles, game_engine.max_occupied_tiles]

	# we need to change the current player:
	# find the current index
	var current_index = player_ids.find(current_player_id)
	current_player_id = player_ids[(current_index + 1) % 2]
	var id_to_str = {1: 'white', 2: 'black'}
	current_player_label.text = "%s's turn" % id_to_str[current_player_id]
	moves_remaining = max_num_moves
	moves_left_label.text = "Moves left: %s" % moves_remaining
	#rpc("send_current_player", current_player_id)
	# if we are not online, we still, the the player changes here:
	if not is_online:
		my_player_id = current_player_id
		my_player_label.text = "playing as %s" % id_to_str[my_player_id]
	# print out
	print("It is now player %d's turn" % current_player_id)
	
func _on_cell_clicked(pos_clicked: Vector2) -> void:
	# ignore if not my turn
	if not my_player_id == current_player_id:
		print("Not my turn")
		return
	# ignore if move not valid
	if not game_engine.is_valid_move(pos_clicked, current_player_id):
		print("Invalid move. Try again.")
		return 
	if moves_remaining == 0:
		print("No moves left -> please pass Turn")
		return
	# broadcast click to all players
	rpc("process_move", pos_clicked)

@rpc("any_peer", "call_local")
func process_move(pos_clicked: Vector2) -> void:
	# Send the move to the game engine
	var current_index = player_ids.find(current_player_id) + 1
	moves_remaining -= 1
	moves_left_label.text = "Moves left: %s" % moves_remaining
	print("click recevied")
	if game_engine.place_piece(pos_clicked.x, pos_clicked.y, current_index):
		# Update the game state after the move
		tile_map.render_game_state(game_engine.grid)
	else:
		print("Move was not valid according to the game rules.")

func _on_exit_button_pressed():
	game_finished.emit()

func _on_game_engine_game_over(winner):
	winner_label.visible = true
	winner_label.text = "winner is player %s" % winner
	# block further moves
	current_player_id = -1

func _on_pass_turn_button_pressed():
	rpc("next_turn")


func _on_game_board_spacebar_pressed():
	rpc("next_turn")
      extends Node

class_name GameEngine

signal game_over(winner: int)

var height: int
var width: int
var grid: Array = []
var adj_delta_rules = {
	0: 0, 
	1: 0, 
	2: 0, 
	3: 1, 
	4: 1, 
	5: 0, 
	6: -1,
}
var num_occupied_tiles: int
var max_occupied_tiles: int = 60
const handicap = 2.1
var num_tiles_p1 = 0.0
var num_tiles_p2 = handicap
var is_game_over = false

@onready var tilemap = get_node("../GameBoard")

func _ready():
	width = tilemap.get_used_rect().size.x
	height = tilemap.get_used_rect().size.y
	print(tilemap)

	# Initialize a hex grid with side length 10
	# filling matrix column by column
	grid = []
	for _i in range(width): #horizontal
		var col = []
		for _j in range(height): #vertical
			col.append(HexPieceLogic.new())
		grid.append(col)

func place_piece(x: int, y: int, player_id: int) -> bool:
	var hex = grid[x][y]
	hex.add_health_delta(1, player_id)
	return true
	
func get_base_deltas():
	# Iterate over each hex in the grid
	for x in range(width):
		for y in range(height):
			if not tilemap.is_in_game(Vector2i(x,y)):
				continue
			var hex = grid[x][y]
			var adj_occupied = calculate_adjacent_occupied(x, y)
			
			# Calculate deltas for both players
			for player_id in [1, 2]:
				var delta = adj_delta_rules[adj_occupied[player_id]] 
				if delta < 0 and hex._owner != player_id:
					delta = 0
				hex.add_health_delta(delta, player_id)

func update_game_state():
	num_occupied_tiles = 0
	num_tiles_p1 = 0
	num_tiles_p2 = handicap
	for x in range(width):
		for y in range(height):
			if not tilemap.is_in_game(Vector2i(x,y)):
				continue
			var hex = grid[x][y]
			hex.apply_health_delta()
			if hex._owner != 0:
				num_occupied_tiles += 1
			if hex._owner == 1:
				num_tiles_p1 += 1
			elif hex._owner == 2:
				num_tiles_p2 += 1
	
	if num_occupied_tiles >= max_occupied_tiles:
		var num_tiles = [num_tiles_p1, num_tiles_p2]
		var winner = num_tiles.find(num_tiles.max()) + 1
		is_game_over = true
		print("player %s wins" % winner)
		emit_signal("game_over", winner)
	
func calculate_adjacent_occupied(x: int, y: int) -> Dictionary:
	# Calculate adjacent occupied hexes for each player
	var adj_occupied = {1: 0, 2: 0}
	var pos = Vector2i(x, y)
	for dir in tilemap.get_surrounding_cells(pos):
		var nx = dir[0]
		var ny = dir[1]
		if tilemap.is_in_game(dir):
			var r = tilemap.get_used_rect()
			var adj_hex = grid[nx][ny]
			if adj_hex._owner != 0:
				adj_occupied[adj_hex._owner] += 1
	return adj_occupied

func is_valid_move(pos_clicked, current_player_id):
	if is_game_over:
		return false
	else:
		return tilemap.is_in_game(pos_clicked)
	
func _on_game_board_cell_clicked(pos):
	var x = pos[0]
	var y = pos[1]
	var hex = grid[x][y]
	print("owner = %s; hp = %s" % [hex.owner, hex.health])
	print(calculate_adjacent_occupied(x, y))
	return true
	
         # HexGridLogic.gd
extends Node

class_name HexPieceLogic

var _owner: int = 0  # 0 means unoccupied, 1 for player 1, 2 for player 2
var health: int = 0
var max_health: int = 1
var health_delta := {1: 0, 2: 0}
var rendered_text := ""

func add_health(delta: int, is_attack: bool):
	health += delta
	if health < 0:
		if is_attack:
			_owner = (_owner % 2) + 1 # 2->1; 1->2
			health *= -1
		else:
			health = 0
	if health > max_health:
		health = max_health
	if health == 0: # nobody can own dead tiles
		_owner = 0
	if _owner == 0: # unowned tiles can't have finite health
		health = 0
		
func add_health_delta(delta: int, player_id: int):
	health_delta[player_id] += delta
	rendered_text = health_to_string(health_delta[1]) + '    ' + health_to_string(health_delta[2])
			
func health_to_string(health_delta: int):
	if health_delta == 0:
		return ' ' 
	else:
		return str(health_delta)
func apply_health_delta():
	# then we diff the rest and assign new _owner
	# we assume there can only be 2 players
	# health delta can only be negative for the current _owner
	var delta:int
	var is_attack:= false
	if _owner == 1:
		delta = health_delta[1] - clamp(health_delta[2], 0, 3)
		is_attack = health_delta[2] > 0
	elif _owner == 2:
		delta = health_delta[2] - clamp(health_delta[1], 0, 3)
		is_attack = health_delta[1] > 0
	elif _owner == 0:
		
		delta = clamp(health_delta[1], 0, 3) - clamp(health_delta[2], 0, 3)
		if delta > 0:
			_owner = 1
		elif delta < 0: 
			_owner = 2
			delta *= -1
	# reset
	health_delta = {1: 0, 2: 0}


	add_health(delta, is_attack)
           extends Control

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
    extends Node2D

@export var update_interval = 1.0  # Time between updates (in seconds)

var width: int  # Define the width of the grid
var height: int  # Define the height of the grid
# Game engine logic
@onready var game_engine = $GameEngine
# Reference to the TileMap
@onready var tile_map = $GameBoard

func _ready():
	width = tile_map.get_used_rect().size.x
	height = tile_map.get_used_rect().size.y
	tile_map.init_text(height, width)
	randomize_grid()
	start_simulation()  # Start the Game of Life simulation

# Start the simulation loop
func start_simulation():
	while true:
		game_engine.get_base_deltas()
		tile_map.render_game_state(game_engine.grid)
		await get_tree().create_timer(update_interval).timeout
		game_engine.update_game_state()
		tile_map.render_game_state(game_engine.grid)  # Update the grid for the next generation
		
# Function to check if a tile at (q, r) is within a distance of 6 tiles from (0, 0)
func is_within_distance(q: int, r: int, max_distance: int = 6) -> bool:
	# Calculate the distance from (0, 0) using the axial distance formula
	var distance = (abs(q) + abs(q + r) + abs(r)) / 2
	# Check if the distance is within the max_distance (6)
	return distance <= max_distance
	
	
func randomize_grid():
	for y in range(height):
		for x in range(width):
			if not tile_map.is_in_game(Vector2i(x,y)):
				continue
			if randf() > 0.3:
				print([x,y])
				game_engine.place_piece(x, y, 1)
			if randf() > 0.3:
				game_engine.place_piece(x, y, 2)
	tile_map.render_game_state(game_engine.grid)  # Set the cell as alive or dead
				
    extends TileMap

const main_layer = 0
const main_atlas_id = 1

# Declare a signal for when a cell is clicked
signal cell_clicked(pos: Vector2)
signal spacebar_pressed()
# Array for text overlay
var text_labels = []
# Dictionary to store the initial "in-game" status of tiles
var in_game_tiles := []


func _ready() -> void:
	in_game_tiles = get_used_cells(main_layer)


func is_in_game(pos: Vector2i) -> bool:
	var pos_offset = pos + get_used_rect().position
	return pos in in_game_tiles

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var global_clicked = event.position
			var pos_clicked = local_to_map(to_local(global_clicked))
			var surrounding_cells = get_surrounding_cells(pos_clicked)
			# Emit a signal when a cell is clicked
			emit_signal("cell_clicked", pos_clicked)
	elif event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			emit_signal("spacebar_pressed")
		

func update_tile(pos_clicked: Vector2, hex: HexPieceLogic) -> void:
	var health = hex.health - 1
	if health > 2: 
		health = 2 # we can't render anything greater than 3 right now
	
	var health_offset = 3 - hex.max_health
	if hex._owner == 0:
		health_offset = 1
	var tile = Vector2i(hex._owner, health + health_offset)
	## Update the tile visuals
	
	set_cell(main_layer, 
		pos_clicked, 
		main_atlas_id, 
		tile)
		
func render_game_state(grid_state: Array) -> void:
	# Update the local game state with the received grid state
	for x in range(grid_state.size()):
		for y in range(grid_state[x].size()):
			if is_in_game(Vector2i(x,y)):
				var hex = grid_state[x][y]
				var label = text_labels[x][y]
				if hex.health_delta[1] == 0:
					label.label_settings.font_color = Color(1,0.2 ,0.1)
				elif hex.health_delta[2] == 0:
					label.label_settings.font_color = Color(0, 0.7 ,0)
				else:
					label.label_settings.font_color = Color(0.1,0.5,0.8)
				if hex._owner == 2:
					label.label_settings.outline_color = Color(.8,.8,.8)
				else:
					label.label_settings.outline_color = Color(0,0,0)
				label.text = hex.rendered_text
				update_tile(Vector2(x, y), hex)
			
		
func init_text(height, width):
	# Create labels for each tile
	for x in range(width):
		var label_col = []
		for y in range(height):
			var label = Label.new()
			label.text = ""
			label.label_settings = LabelSettings.new()
			label.label_settings.font_color = Color(0.1,0.5,0.8)
			label.label_settings.outline_color = Color(0,0,0) 
			label.label_settings.outline_size = 10
		
			add_child(label)
			# Position the label over the corresponding tile
			var tile_position = self.map_to_local(Vector2(x, y))
			
			label.position = tile_position - ((0.5 * tile_set.tile_size) / 2. * scale) - Vector2(6, 0)  # Adjust to center

			# Store the label in the secondary array
			label_col.append(label)
		text_labels.append(label_col)
     extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	if visible:
		visible = false
	else:
		visible = true

             GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /�@" ��mۖ�Ѷc��'j��[����n�L���+R��Bw	D���}�^�,i��<���t�zZ۶m�O2�57�ssssk� i�ܹ �!���133�Z�n�Nc۶�2y������̼���j��f
ے��j	��=f/驮�7�W��n���X�l�m���-��*�ۯ��q���r�� m�X���s4�����G�,�F��3�:A�le�v���܁�%��� 7_�Z�^8ΊH/��I:w��i�f�ro/vNϮ�I�΃�ۏ:k1���|U1J��\�w��Y7_y��d!(�e�C'�Y�ȋ.ߌw^��&�՝&[��9Q��.�Kt*;�\,��W�+wXv�Q�̵J����h���ɚ���BX|A6��s�ov����^)�U�=ry#W�(��j]�bv����Vz�Ҁ|��*Q%���f+��>�(�D�.&���W�z�0�X�NP�y�Q�a�|1YarfZ���>���Y�Y���(X�I�u*���պĤɚy�I��A(n�YUg� ��bn4��W�U����'$+U��:8�T��K��WGQi�7Y��Ӻ}'�|t�PU ��C����U�9����dUR²�h��&+���C��y����JZ�<��1x=u�fP ')��h���(�_��4�v�Z��Kcq��ʱ�q5���Ѹ^�a�rr|G���E$�S�k3o<s� �0t�Y�`�5�A�S��j�s�!����t�rݾD:!M�zcgAa��d(��;��/u��y�:
*%��fk(�e���@H��A!�^z�Q��R�|lQo��j�F�c�B��U�9ꉦP����`���n��_"DggQ�!UAI�ŏ^���� `v�r=x�JPs�3���ҽ��q-���h'��Ѩ���;�=�va`Z1L�Yd|I0y��+.�Y������h-FkF�WD/�=r0��(fQ����&`q���d�
J3�
J������k{��q�{c�F�6�u�Z]HY��}:�]?:x�Jh�3��׏:QG`jӱ��~<~����ب��C��(i0������J��.
��Q�f��w�o�K�kt ���A�p�l��-N��3���%�ݧZ��]�V+�w�C��Q��� ��>�L�p�o�MH�y7_�z��+㼨�A����\����mZ`�t�A���|����,����SR�Wǃ�����*n�	�����}�Y�`�v���o-���ō�r�Z��I���}���+;�{���IDj����M���_��OU���H��Q���(kF�9�X�t���Z�QA��k��̭DQя�A8�a�d��G����JWo����֙[�g���\�C������Alv��5�ARv�^%���ۋ�ITv��o���,�Օ��U3:�����%�Tug�Lv	�%g�5࿴}� �%X_Z�པ^U�d�Kя��h9�l�.k^G��=t�~Z�Z�������_��a�t��*5�3[���ނ0Y�����t�.��d�te���C���Щ��z�ܠr��Tԩ����}ykB����V���AE�y@��;h���3���	O.z��
���Dy�����{�3;t �^�;p�U�����Մ�1[Y�5��z�V��i�d� vx�w@��E�}�l,N���F-hu�PUhdV�E�-g�5`,NΔ����hⶣ�N����`�l5[A��lMh�9a�x��-u���<�c���L�g%��69��:ݴ���E�s+r�J:�v��'H��Nz���(�J[��Z�?�댥|m�ύ���t������#���vI��ޢ`����a�t��,N���F�$���������^:2�k�E�����ȡ�V
	���sUm��C�1#������uTl:vj��e�vRf/&5�!\�\����/V���������h(x�>~���|i0��΅&����WUg�Twv�xc ,��C��h��bR���n<s2�FNv-�^��d��DYJE��#��4�??D�Dу�b��Ɖ��@���h����S+ʊ�=?0�R]o��VtOO��W�6jp�`�t��f��#hT�yz����u��!	�ǻ�
�L�*o?���z �f7p����n5��d�t����$�FھӉ���3��x�5�
x���%�ku�餆���h.�U�ֿuh⶗��7�501_�.?�����5<�� h2�'�5 y���®C��I��/���XgUwv�tg�'�g[G�FT*�������XZ�����JJ^�9
^y��fa�x������>�RT#l9�V'��;_u���}�d����I>�+�v����3z9,���Xt��>'�-#(�� VH�u+����׉��w�Zg��w�7_�֠S޹��������c����j�8�%�C��N�5�E�Ni��a��ƺC�EUJ\�,\M�wfUL]����-��ńαk�Չ��]/�1�����Q�:d2�J�T	KW�� f+	�A�BU!Sֺ>�]���0ZChC/
���	*5���� ���ƄD��.���w��8=y�z/�*k��:c�3/�Du1[�tl�z�N����J���5mߡ��ޅ$�&���ޒ��=}Ya�t�\JڬczI0q�@/(M��(f	���0��,*x�z]��$n{�����_,ߌ"���{���H����d5"n���v԰j������C��(i��Ѫ�E��d^P���Z/�K4J;�<�H�Fk�N���$�����ս����P�9w��=]ge�0;���J��u��_����h���"�~ߪ�ҽD���(4�Z4q�#Q�����¤|i���еG�.�y�^,&kP���:.L�/H/qZ>K�!�8���ً��6�}�.)�����
Ј�<�t=Jh@.�%Ҟ_���8�`�r�yF�P���`�B�)"S�B��¨��WΪ����	���Nփ
�D�U��6<9�=`�_�K�N���m���������shg��s��wlmmo�߭۷�R�N�Up�d̜�$AX��9x���[��=Q6��tY��J!iכ�@��d��C�s�1[ُ" �:�������`r����ΆC���<sh?�^,�%>��C���D��պ��Z��=@)dT%��� B���~�mj���{��@��s��G���#��/ՕR���FhӍH/:�gY�@�=o?r���c�g�z��E/*��N�o|-�'�}��o@Oq�������Z]�(�\���BDrUv���}�ke�U�RqMF�N�P�f.'ab�*��}ҧ~�������Z�ﭩ��Qں��b�Sz6Z9�����ř��I�����fg�e��n߹�
���k�����>��������%P�(%�)��l�>H�3��f3B�{����`�t[������C/����z���m�����!?�<��|�/kB�
�6	�>���*B@@ϸ��q�e,��*�=�d^��� ��,���P�x/y�
 �x��ӭ�r�ED�/� za�l�=]�Ʌ���:�$������cq2w9�����_�;_q8Q6m�O���ӊ�d�n�����S���u��!s�ɺ$�!hX��`�z����D~'� �>��x=��A�l������9��h���09�r;t���@l���z*��0_�`��~����r�ߛ33��G��`h����� �*�.:F�<(v�����jyC\�=q�+���x)=^6@��D��9Z`#���r]Bh2f�b+�����+N����|h'�ˌb>py4[�ԭ�U� ��:��r�Ȯs_����`,�wE��.AU������AԚu��1����6@q��%��hM�$lƾ��
atM���R�b;D�O`�����T����(�A�yX����A��`��&���V��pxH9l�	��HySj0vf1M~;`)$��[�BfUHz�r���I�R�*2�����`4�$��CY���]P����䀯N�o5]�#���+���ń�����|���\'d��$o���P��Fh g�\�6��;�*�\����ρ�J����~�G$X���N�\��� �a}&(3�C��
l@n�Q��`�5S�e��_C)��]�ɑρ�Yz��R�$��R,S�O�7vA0 d�? ��-���U@.�K������,�p%�@Q�0v��9w��X���-L7�`����w���[Ȑ��y�!8�5�Qkldt�y���!p�����GU�|�F�L��@�N
�G�eM��=�#䣾��������O/���ֽ�?m~�	-$���/���}����i�f+��������������׾�?Q_��R�&<����C~���N�7ȯ[��ل��y��~K 	�CP\�|��Y���P 6��`��ˇ~�����/���wy�`|�x�I��U鬣�F�R!��/�Mxր'~�Ѩ�}��7�F"	����:��ݪ�����[5r�M���?»�&ԃ�zgҧ~����\��?H��@�H(��6�n�"O�+�����>���|�D� E�H�V��r�z�qW���7��a")�������q��YC&�R�g�)���A�׾��oF~��}K�?�����z��C����
���c����~S��G<���+ S������=�z0��A��io�׆��o��~���{���$��������
2���3�?����}��;}��n�	dr�l�!�쐝�m�=L߁+q�/5Ȥ�ܞ�g`�>�pa8� / ��r�s�.�w�L�P�߷��.P�`"L�I��@d'|���? �>�.���`",�{@$����f����m����f�-p]��p�|$��Z���` 6�d|��)؀�6��F_���Y�d�ε����P�_�?�x�~ �a��>|	/�@�ρ`�/�ȡ���J�d�F��n?��^�`���v
�7�1\��0����6 �|v����y���:�r����a�d�3���KZ��?�0/��?�?�>��Y��l�)� |���O��G���C��&�@�RQ�h&��}�Px
v���c�� b�o T4u�Q������n6�l�c��+ zx���
�����4����d�>|	h���������E�����~Z +����� �����e�����,b������}���� ��p
�^�}�ש��v���Wxv��#����!XH��V'���6.;� �@R����p�w@��? 
���U�`qr��V�g@���������>|��u�{~8� ��f�t=� ̿�9��|[A���-P����}��!����V' �� ��b�w�D�B6$C��<�Ϸ�PN����,�N�J��+� �=<����ʱ�r�� ��/!Dt�v�:��d���,��5P����:��� � �_�1ã�7`�N��M/�~�ſh� ��@�~���N/��	�:cGN��`������ 	HJ������w����	�����D��ÓZ]�S�����T �����v\�A�� B|�*iێOI�A���Gq�u��&̗m���? ��r�Ba�l��d�A�����$��}k��ј���¸�Zo�UQ���1�w�	�;�>�lh��i2Hʩ�_�{�d��ba��+��k����>r�&X���:x��/����^�����b5Yr�l�԰r;���h62t��y�΃,��o W��?z���$q׫@)z�����lTvp{hH���^�h"@Ȑ���{��⩲�VC������h�6Z���[����E�P� 7����	�`�|�7J���Q����L� (kmDt���|�����x�݃�6P|U
%�R���A�b�3�h�v�b!4w�����A��Z��d�������*�����[�Q�]m� ��b�'�^)P%,]�V'�;ڋ�hz� n�r�!h�fP�B8{���Dtvr�%9�z���8?}hT��w�.k�5��289�68Kڌ��u��U*(ͺWV'(��SL��g��S����Z� 9u.�ȑ���Vw��"�Kӊ�hV'��<.�-��v���>
����^̒_����I �(\�K�,��w� g�|!qף��~���`V1ѐQU���C�5h43`t�<��A��l0��U�^��UEq�L=m��0���G��_�@#T�t/s�����������;���Q*iM�*�D����6O �}�Ags���A.V��#�fۓ*��G$�ӊ�1�1����`0;�mx_�V'����%�}ޣ �x5Jd�V'ɻ~6< _ k�=r��g	�/'���WI�.ߌ&k�i2�� �!́���h2f+�6�Z������u֝W�ep����Y�`�Z]���W Qm��u��s�w�cr��!9o7���/:��'�����:A�de�zJ@�r�������R�*�8/9~�;����Q�J���՛�8�� z�V��ͩ$�&��|
��:?:,g�+g��Ձ�g!&;jz���W�A����U�y�h�QU�� �ƼG�N��=G/چ���vXv�q��5�M�u�����b�+����I��h�8�fӡU�j�dY;~��              [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dto4ttx1ny1k7"
path="res://.godot/imported/1.png-515c813a180ba5fd2e61c8e75c4cac47.ctex"
metadata={
"vram_texture": false
}
   GST2   �   �      ����               � �        H  RIFF@  WEBPVP8L4  /��! ��mۖ���}mT��\~]��w��A�n�^���H�2
���CJ �\�tww>F�,��y��k۶%ٶ�[�}AP������k�;��k��>O��m��m�V�s1x����1�������j����j�J�%H��ͬT�Y�h������):��/�ڭ�zA׀3Kֳ$xqT�SO�Q#�F��ZL���^W�R-D'WbꟵ�����s��ޡS�,=�(��ٽ���gmF��m�i7�A�y/���mTrq5��^��6s`��3g�j�U���	2fgF�����Y���ō.��0�2/w�F�Q4<r�F�mfI��ݦ�E�R^���Uz�܀|���n�زU'�����.Z�#_yL��XU/�|�(��[���jv��Mq�
�uM����"QIhx,�T���RV�nSb�����,B��n��Ywo��[��b1Z�I�`D�D7�F���n�G~hJ�q�ܺ��:JJK������U�L���F]!�m\Drq�^��#���KN%�޾�Π��$+;H��]��ڹ�� ct��ACu�a7�/���hي�K��(ܹhT��F��sc���ɹk3�hi9�q�)�� ���<�B-��N.���b>x�^����|�x��7}��������/\��ã6�;�۪A��	�c�Z;�����m�⯣w��-����`-5��CGQ��rp��X��N��j�gE������c/�z�x�V�`�5č���Qw4W���v7�N0�m��� -��]��Z�,krȐ;9� �zٸ�\�M�'�|��ֽ�Xq�GO-�I9}nt*1��j@��Q�G���0��e1�K���
�q���cY�:ߍ΢arf��͂ĆG�Ϛ��"	���� X��=v�RQiu]A�R�\u����XĊ�k�G�t0c���CuM!K�[�t��,kr
���МWn�wѡ��]�^Vx����(���c/@��l�0�HTk6��1�]2����P��]~�ː39������p�� �[�/�0�5%��o-�N�Ν�	�]�ԹaUb���D��pD
�+���f/�c <ye|����X��2�d�|c�ңW)�E˅B⧫�p�{������'�MWo���e�/�:�	�ǯ��[O��'|�9���>ȹK�&E��ՀP�z�;9D�urDj)at�]���_�N����*a�"�(Bzv�w�PL�o�:)a��FVTTz�R�?p�V����F� �J�0)�� p��z��]���XUWԺr��&;����;t���I.2���R^�*y�x���o//���`����-�՝�)��Vt��_Z�Y��� S��N�w�ot���� ��Ҫ͋!HUu�L�������/����ZБ����������g`�/!�L���ơ��ؙ�U��$�av2g��ѩ�)��d���B`xCݱS����ĩA����PQQ��[\���G��	��c�ӗVTQ@��[h�k�� a���"�7Q��C���:mxQA�#������T����e8܍��tda�f���N�l_:�j�z���iJ�ɐ1>;z��Q��9m,^��Vl^0:ݨ+4j�"�׋�0/W��G%ђ�@��6�*u����!ހ3I�������H��<���W�R�\4�U�����v�lc�;|�[����uWIQ��xA�o(:��t�Ԣ�k���a`�t7XK�ڎ�IEQ�S�Po��&�	��c,
&g�G^�	����8AN�Q��������wv6+;���=�"킪��ȣ�7
k�\������5Sg�;�egk��uD�#|.^k���`5kё{���G9RT�������z]{�(TT_�WuP�\��A��w�������[0��N�n,Dơ�wh9���+f-x���3'3`e\�3��Y�!V��ZT*iu�(O��S+�$�����9�['9������Sǈr�GO-fS2;s�V 9�Ѕ��:�
L�mz�0��8���S��[GZ���ed�,���f'�}���<�(���dK9�G/�jܻɤ�&C�ȓ�Fe5(�~�s�V��wf�zvA�;M	��)x��0o���������GAK��c��A���7��v�Rǧ� �V�]r��-�:4��� �7�]w�����g;^�g�a�쵑��:�>�cz�������N�*+=yn�s<|�������m�����Ny�C#��{�tL��Z����>>�i5n�Ƿ,L�mC#��u:�͛���	�Ł�S�1�X��:�1�F����PY'��+�$�8����N[�A
#�o�3�t�.>g`l@�A��&��u��;��re�ө���ll;��ĹEg�f� � ����ՌιK���Bi9:^��� +;[;�Lu]�J�6 1�A'ܨ+d�;�7�e��N�3�2�DQt�a�xA共Y��6x	ِ0������['(u�kM0b���X!<�Q�ɮc����`�Lॵ�P�O�q��-�/�=ƒ�4<�A��7���eq�u	^�װ	"���0yo��P1H����d?j��p�� �Ě�+� ��W�����^���-lڍ4'}|
�:>[[�����թl��+ (�y/�h�]Vv
��z�3T��3H�Ҋj0{�����쬄7���#�e�7��,�S'���əy�E��8v���U?J�/�8���%刄�ؐ8˵�Y:Cu��?~�S�fgPx��G�xH��u��{��d�j��7zn7%�#�˖rt�(ΔU�W���X�D²�g���6�&�	��~gb��Alzu���W.�d��:�J�ݽM{�����6��N����d06mt�Mc����M�c�϶U=��]�����f�j�!r��9�˶�OTJ1��p>�o�>�Ȗ^ +����ʳ6�^
Z\,Fk ��Epdt^�@y����
�����:�R��ex�)����Ge�j� 0��6%�׆�84Bu]Y��r�0�kx p'�`OX`��@(,_����VSiD]`��-����C|��;��Y�Q�s~�A��}d�Ͼ���{�A8����A�k
�K{�����ЗW�(���i7Bv\��đ/�7��m���_�(���}�S�����>�TB'�}��z�3��PQ����ֽ9�7�ֳ�ë��PKu��B���(� �p�??�����ɿ-��_S
{�c �W(��	}��g5
�+�����Ò Ôٶy?Rk�v
��up0�k��p�C$�x�a�Ͽ���~�wJ���uh�E���Dd��-Ap|�е��󕅑����_�A�'��|Wp���>(��oI��O�<� �	,L�mFg��,B����c�v�ֲ��=����0�~��i_�Ŵ��"�7_r�  �>2��c��g� c���q��p,^��C�3��V��)8��F@�9�����?%���� �T�
�����r�\�� Cq�����y/�8�-�8� ��c����p��9@�^�/�}H��fvRQ�����F]A1Y	��I���ܺ� ����B	��N�)@b��c+�Z�rP�c�Rς��Y���������u,Jk�SJj^3a�����9?�ް�ā�y�g��73��T�+�
kw�Q}SGAp?mz�Yi�G��~g28���x"���Y@�,Y�"D�����o��բ�QIhz�PT/;ʡH�8�������F��b�O�E+�~�I���r�orI%^�t?�^�u2-�M`���o���/aD&�h8������K���+z^X�8�xH���!�{M���h��S]S �h����z�C�a?���p�V[�`h�n����'��73J���u�՛�u�g�P\,V/(<i��ԛ �3���g�d�j��s)_a���Yws�pP��q��$~����Au�Cg��K��k�1TTו��������`��������G/a$�|wo�r���:��$/��iBz�8���z�R㫈�PxZ��Y���66#;�M.���)�Zp=si�^�r��%��i�������qQ����Q�B�%���Ç�u�D�[��z�) .��2D�N����s�)I�9[X�F��Z�D,N��Y�������jP�`�&8�ya��M�r�V{Q�q�v��ƍu��|� y�zk���o�,�Ӆk�~g��S���h�2�\U�e�����^�k���˟d�O�3)/G4JϞ�HqWo_���!	�mf�2/��V+���wl���Q��I�}�-�1q��= q
���V/蚵x��U�KS]�N`/g`�>k�q�Ki9���������>�]�Hr'p�ً��&�F�Ew:|L�̘�����s���`4L�m������D��	�>{�v�b�tc���I��s��%� �C����<�2)�,df����e�Qd�h��Y�L[���pl �,���i�2Fk����Y�96���%Q�0^�ָ��,,����L�(*�gp��K��#������.����;��q�BO�A���r�p��o2��}s���;��VV8��bb�v�b[����r���]�[LN^ZF`����m�lc�=|�^9"��M�J?��^J��:D��g��0>�֒ʹvN
�f/�N�0	��e^�R�<�� ^94 ��u4v�W�$x��⵶x�2�x=���`�|`~1�M�Z��a�E+ʁ�Ng�'�c��`֜��A�u�t��093y�ː6�t5�����u�D�u8t7m�����8|y0!ߑnB�ϭ(*�x��U��34`eB��@RG�P8w����l��>P�;�(t�V"�������g�Q��hzc��p�װb�Wwo1�bт�������CϣJ�^��	�9� O�� (.V.�j�0
BY5L���N�O�n��mF��}�O����/�"8�V�*0=�N�7�2y�/�ύ���<�۸���>_�/���
�`�n >�La�tO9qnE����S*vc���EwK�9z�U�>���B
�C� {v��<�G���X\�{�,L���5�rgQL�m0窗��E��H�a�CJ�-x	D��r�>g`|�X��Yh|ЗWZ���t�RC>��5�W6|�����>�/l��ߧ~���}�?��@ ��̪���|��xa�~o�~+Y�S�1ӽ�w�9^J�@��hp��G�~������O��1�p��ӠUܸU�8!?$!}t"����F�I�Q��[G��<7�7���c��dp��G����\�~G�z�̧����Ϝ>��c'K�=ynz��ډ���0pz�Gs~����p	N0��_�-�R���c�� �18ȟ=� ����N	�'e쩕�zQ�߀����l����/J��3�@�~dZAP:jt�	�o	����s�;v�R�N�ۖ�Q�y���X��K���������#�.�ȿs�}'�2���D������胜�6�A�۫���њ�(��Ż����.���`�1p'x'���@nm�ptZ��$eQ�
�zc����S�x�{���_���� � 	Ҡ��m`��@�$��Ёr�k
���CA�6;r�ڸJ�����:1`eR�7�����������L��c W�0fr�ZB�RR�n�^*��M�N��Z��jT�����	�)�)�yΏ�=���5t7ħ��Q���w���y�%���Wn5x�[�{���r!
�!����E~�_���k�5Pj����r0;�����%	˵��{�ʓ����߃���Z�j���<�1�������y�E������ �_-<���M	�JV'����Yo�^dC?o�s�ZA}S�E�s����{�j`��e������6@�KX��c苠��\�����K�e����w�BU]e��O�F'��k��ㅱ	#�C�ȷv'۪�S**��WV/(��YX���׀�+������,N���\R�'m)'�R���b�K��b5Y���K�#�<�a�g��H9�Y�Zd!jx=|�T,��"�����z�ҶjX8�O�J�-G����󋙆�b5.�v;8��њ��e�W��&��4�N6mGW��ި+��XLX��C��t�����?@�*޺��9LV���Bhz�!�NE9�Je�Uue���њūy���|���b�3�ͺ�ubE��G��hz���%Cq�uvL5>��6��=�������QX�y���ƭ^��q|	@~lُ�9�E��a�z&\��t����2�V2ӳ`|	!1�Fk�Q�lڍZAP��sv��NO_Y��s1흳z�V]Sd��O ��A��W�9:z�xb���:{+�N|��A+�֥�:f'˷s�(����br?ȝ�t\��D�A��F�>3|T'�w� �J=�si�>�J����dv�O�3�ubA	�� ��+;]��!��Azv�0�G�<hp�B�r����{E�꺚�ZD��(6<rtz�͞�Eϕk]s�ظV�:ЈV�:�󝇀86�r��'m���Ov�lvz7Q.^k��[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://b21t2ld5ducjb"
path="res://.godot/imported/2.png-3f238cfe6181f9f93f40cee36336f408.ctex"
metadata={
"vram_texture": false
}
   GST2   �   �      ����               � �        >  RIFF6  WEBPVP8L*  /� ! ��m��)��r�0�<��$E@1vI��nݶ����;;v�[,Ģ�ar����e's�z9�x�o/?۶�@���I2�arN�c��sG�Xb7��b��cTcL�sm{�ٶ�I.f��*��b���]�)�=���lIg�%H��M�e��Bt'� ����Hu��O6L�u./�؝�n����ֻ�@�{�%1-�����<��5�w ��DyN/o�hLTl9u;Ν &�Tpm�^0��1>42��{�p�]��A�I���҆�ɨ�j� e�����T2�����(�����^ �W�$DF�qp�6*�,�|����һ�Z 8�����ź1������ݩG$M��S�t��c���H

�{K�/.'_VuPh�؆S��Kq]�*r0v��9��ZI�O��{U�am�~�t�����:"���1�����@N/���ޤc��j��m����{��'6Ke�D�y~�Z�U̿�./���OL�����j
�DF�WƋzS>Y~8��ONr��������:�#�&ؤ@�v�_$-��]-"Dǡ���6|2YG���V�6��/#�&��d./X�t��%~JQTU�&)b�����N���S���;=R5J�$�|�]^й�.$y���mNNt��4s���o��t�l��tW��ѵ�����,ލ}�S��g���\^V�o����NK�Awfl&xm�o-����N�����(�ݿ^��z/�$� Q��l�C��&���k�nXYz��G�)���;��� �Y�ie9����l�N��mӹ15H���P�W�Z�ه7��w%��Ô�L�j�tS���Q�eX7�\5��W��*A������I����wc���fw��)�uh5e�=��ʰ�j�ĺ���j�U3��~���)ֱ{-k$e��T������a�Alr�+���J����"VVxme1E������l]��P`�l��=��[uF>Z��ﹾw�S�!Ӎ�%Z����$�WU�!-/^u��QS+�|�L��Ppmq6{��&�'up�T,��]~�m&����N��N�7���P*�L���-?6'���N&�fH���w�>[9���C���.��`%źc�tZjG�W��p�����ɂ�����:�8�\�@���__��̃N[ϒ�-�A�s����B޵��x����P�r�ѩ��[���4yhD���:�:94a�l�yŴ;|������\�o� =jL9���������NBQU��ƙg�)�X�����.M0i�؜bX����F'`HE����&��U��i���:��� ��2�x��cu�Q���Wb�*��0؝��n����Tv^2������yז�&�Ѫ��au:{;�>��'?��xa�����'�/콴�E���CF�ז����VQ�#���bwJS�e��S�Ow�S ���U�>������[p�Q9��8�d��`Rv�^�l<�
�x�UAOW�EH���7q˿�f�J��Z�wpo�e� =һ�����	��^��A�:���$��0������n�}Cs�)4c�������ڜ��D�=7�|~,���-�J��N'�//Q��l߭�aw2{;�X�$�jr�>���S�������2@Ga��EY��C�1��x��:��6i53�|T9r�c�K������'s�K�=�ߛ��Jw��A8���}�ٿ}���]ZV�>�_ŎW����g%�����{������*^]���Y���⑏k`a�v�?�_L��x
��C\z�6ޑ�� Cf������F_0���FS�b߀(�3D����p�V߻��!A|z9��):��=:�{�л��ȁ�@�}f�&sx�|��� }��	U���2^�}x;�`��t쒰�h�i���N�מ�%�VK�u��i�f������ɡ�YBv�6 r�|a�Ú��
#mZ�eT��0����c��@�fC��)mr�����E��V�����h�@/�K���"<HVp=��haA1Z��Tw>e|��';G��qp��C��X���	ٙm �G Ȥ�M�t���	b����\[QU	��s|۽�8�l<v�b?7 �R`�tk��R�f1ɭ
�V3� 4q5��3�QǑ;��wv�+�pC��ԣ���2DDϥW	(�F]t�n�mG��E�1S�C2�&w�'m˜�,+��\Y^����!/o}��&p*�����N���<DƏ�*�ߊ��d�I��d@��R��jh7��0\|��f��i��<+��;�h���� �}�܀�/H�A�p@���>L.&m�WԳ��r��k��9Y�'�M����K�o���n~ρ�c�/-��ɼbR�K�\�K��w��EG�"��N�-��tQ1���޿Y��[��nm0:E��'���*E��`w
cs�z?HB�	�_��:7�د�q�b=��E�"������4>at
�-�k{�%kz�Av��8���4)?������E솧���4��p�]�d�{�(�����Z�6{�Wʮ�����?���y���B���@������VS�Lo&������"AT��h
��&�O�3�ط���{��w�f*A+�6s�I���}�.�\^���sd�I���'+k3���ɦ���_@ǘ`Ȇ���f�bBq]����\x��N&�������d�~�����>�����!�Vr���.�W�>@H �����./`6'�7����1)?R�Co��34�6`�+S|ؾ� H])��;���AHn�9�պ�t+ʡ��՝כ�.�:�'+{�i�s��^�g�^�]V�y�)번(����b���j5&���.���л~�Ym��Ҭ?��π��= UYI�S��r�� O>k(�����LʎU����z����������J����d�[L�>*�,#�09�N��u��S6��+큝��@�i�>d�7����.k7�%Wɧ qz9pk���M������$Cd��p��������� �� ��߃�X�S[6[M௸�f8g�U�I�J����:�6����ti /��-0=�O���l�Ue��G�����u(V+I�)A����<����ˏb`y�P�t��@U�⫤7���)b!A:V5(k�?�ǫ���hC�@ǎ���q��v��+]m��MvN7�U�MFA�x�:� ��Zbn�e?|�������k#��;//��&�g�'Oe�!��>%y�0?�pI뎽�	�ٺ�+�A,mrȘ e�M���
���k�� y�!at5�GU�e�0f�Z�>"c|*�>�=�Ї�o��-@�A	��<�w�5Đ`��Y�M`�ka�ޑ���@��`�f���0���]Lw���Q�	<|�\qۚ�Ʉպ 
 .�������QuT���������AhZ�j�Az� �W����9� O���d�jzOs��CL��6�:�eǥ�Hzd/�H�5�G�Q��	|�XH':���ɮB���<T�����+�T7�_(z���K'�lҁ[K���q���^6��f�N�!��D����}X�fNvN����W��N�^�V�`6���K!�>��G�4����4IQ�8��j{��6�d��S������6K���� Rٖs�}g�앟-��Bi����N'��t�Da�sy�g߭)F��O mr�����O��8�	�GB��+en���Ѫ�����)$����48���K&@`�����W鑳�j�t�G|���a�L�c@�Ua:�]Z��S6�	B�X��/�JF��t�.|Ō0n�q���M��C��@z�5L���8E;���� ���PԲr@2�ģvz�:���L�������t�������U�'�X��0|����qp�?�����]��t�Ub��6�2Y�ݗ�{<pkT�4��-ԡ{����T��^0p�C�T�Yp84�ZG[�F�7	�?�V��N{&�p=f�T�}y�ؽNX-�T��Ɉ����I<��Lv'0's�i0<��0�F'�,��RT�AaTĲ�=�4��%�ȁI��
�Գ�0�܀� V�o��AG�VK����a|I��7�ٺa�m1<7�?�69ʱ�Q��k(�Ƚ	4������҂k�ҷ�� �O�&�0j:�Ͷ�A����#Clzc�V+�ٽ� ��!P��K���`w2i5��ө�.!�^x��I�)&��Ŕ/�(o`�����#|�h$�9�A�e�v4��p�Y\z��X��C'X} {7|�)B��X=���.�Ow�����f�r�1�����0��n6�f���]�@��M*�����dU)*�:m?��%:��]�8��m����q��y��<>[�R��v	^1[[�-|-�}��hXbvVw��~�G�^`�C	��,�k <�t���W���"�;���90�t�U w�s�*4,(F�e����I=|�|@���)��0����+��2��G���ÒrD	lN���.�*�K�2�d�M;�?��������/~�������"�V�o����m
$���#2+���C��l��2A3��
��O ���/B���5_���/�/�����0�"N�����j:O�Y$e�NǪ����U�������7�eP�it�����m5x��` ���_��}��?,��?�C+��z���V���Au��s��%�ǋ�qp`V�cW¢�:>�ǻޤ����9 ����a|c`$�����e����/��_�`/�R~BR~��w�靟&�M��*]^��^��:^0��?��4�ރ��>���LYPl/@�4�=�[��U�YLr���ٶ��\[��{}���{�˯4������Ӿ����s����: �`�z�@6q�+������˒x�u���l�f� 4�%�����7�it������?���ϾV��#_���`��.l8��.'�bҫ��c�zT~
X�(��ɪrX �Ê�?>�"�70����o���K񻈊#T���F� =��l��;9�g�_�98����6���}5C�IE��ԇ�ɒ�`d�J���u㱗łt:񬉕�{��u�0�V������ס�iG	^\�n�z����b���.����O�Z�e��
W��)���ʹ������A!0�����}�	���ҩge�� k��}ļbT "~.�
rm��"=����z8
'�k�	����3��COov�jQ���ֹg�k3��b�;%s8YY��	�ؐ��������H���fSDG�
����a�G� ���08@u���_��\���������xe�:ި�{��ިLP\~���J����+�y�����b�Gm[���yE��d1٭	�V��+��N����@)���s�.1}��&I~���;� ��N�?W^�Ѹ^���|�`���p�aw2v���=�o�9��Oa��F��ו�a� ^�l�Io�W�RP�e�#Ü�duJ�Ի��)@���l��}rzWD5t������aw�z���B�p�]9��z������j��Pe� qMænf�S\em��d��V��e�Gz�0e=;� 9���L� P]��Z]�p9�k;��p�h}.,F���mу�.1��= �����'���U������ud��-+�S(�ӵ�{��# zS !;���͢� 36�٪~�Nc�K�����6u�OM�rh�zԩ�.�}��9��w�~R=bs�}x��I�˪vyA����*h���`�f�{E�Q�f��K��ӵթ�	#w�G�l��ѣ�˥}��g�z>�����������3bS7���Ȉx����#ޥW!�q����0z��Z�kT1� ��W��,.��((0z��9�|<���EŸz?�Έ��BT�\~�x[�]� L�ά꽔����
Fȿ�p�A��uǞP��6�KO�-�S�{�,6�1�������.@t|�ks�m�#{DȘ�-�ؽn<��2U�Ufw��T�K(7��s�1Nl�v�;�r8YR���ڌT��j��� 8�ên]���0�)�;�.+�>�%Եw�5z4XT����������hs�dq:h���=��}2R]�>y|v*�
��rQ &�n79����(Cx�?K����]��.����� ���-��{͉��m<v�T]�]�0n�1[Ź��{$�#g+��ZI���X�y���w��G��9rmN'[N�(&+;��`lN����X����n�y���)&�nu��9� �n�9���ާOⲫ~�(��""��b�n�V�߲�s�
�J]F�A���)�«�(f�l'���Mz���1./          [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bh1rsavexrifq"
path="res://.godot/imported/3.png-ab9dc1e38b41816b4ae4b69d0cb53034.ctex"
metadata={
"vram_texture": false
}
   GST2   �   o      ����               � o        �  RIFFz  WEBPVP8Ln  /�� �m����RD���l�"�i�:j�G�mw��FP��nP36�;�m��J�s�f3����d۶I�y_,��@�n(���l3���(�~��PM�Z~$�Vm۶-_�A��ַʁ�Ҋ�Xj��8z�7����6�$�ޝ�� �"���7du�bT�v��^�����7������(�4T��t�m��p���\E5l|�q��]b�%[��yדB�W�n{��*����2�|F�RwR�����w	��FD>��p�M�c�i��P/�561^�&}vO�MH46�?$o=�7�l�n���/޲ƚ�@ʁ���7Zʌ���A���j���F��C�Ծf4��1�r?K1Mp����+Rlz���й4�p��.}��N:��q�.�*�Xt;1xY�}Kq����졎��J�e�*�*�>R�. Y(��>.A]�)nȃ���'h���\B�w���@���y�P�+X���Ƭ��.�l|��v��H�������$֝G�)�̼\��`����d'��>+�
�Ph6IQ'����h�Z/�2�N�M����U��.;��R|�5��A�Sj�|����'5��N��)S�W��k�X�8*Lv5y�k�h��]��2tZ� O��Ŋ�Q&Yn�������;M	L�cm�?U�/����Ic���	�b���>4a��D��K�v#G��v:+)�����M&��uw90.A�|��#0�7��;>�+n<�uW9��1�|�%�~��G�co/�wFC��*����T�V���厵�l� ��bJ��etq��{|�|�x��ߓm�o�{� ��V�����q����Xy?�H�I�\ H^��W�lyc1娗N�u=b>J��i}#���j���(����cm�̨i��Y!�#��}v��N��W�ɥ�9�l���f�_Oa�`�?"��Z���A�D�^�g��@���UA�����q�kQ���ٴf �С:\O��R��[r���:ݵA�lY�m�*n�&�n��,�J1��r�m1���(�w�A+[p;�C�5�CWo;T�����'�:���1j�1�Mg�����24�F�'�dJQ��5��\�XIP'�56���g�h�����p��Ecr1�z�J�L�_���2�Z�mb������Bj����&$F�zR�F� m�o�MXR�&8�i�o���cM:^i)�r��-�n4���h�!9յ��i~�lH��v�2���-���3]S?�*�c�c�`4�4]�hVb��f��1�xk.*́O���|�k���b)�t�\`0j,��DRdR6�v������U,��2�r����^)�����:�0NU�l��?^�6�\E��Ƴ�t��5������$CX�-���
���a�����E��,3E����D�4����0�pg4�-��30�|A0�z�}���?��f�6i��횺�D����ׄ�M=_�	V���j&��;ٵ!�e �u�� �y� ��@����q1��Ө/IM�h�I���I	��]S+Zb�����]W\;��`At*T�1�A�pC�����`�˼�$&���\,��d�+z�~�ʅ���:��M�㯹 �}�-�07A.�������ʟ��������&"�`��������l���l>�a�8<nSb�A��rU�����Fu>;
��lPs��l�%<���^�FM�;��v
�s� z�X��%� �,����h>�vA�D�ݓ�"m�r$ˑ�8޶��y7JA�I�P�;qx
�d@)%���Q�i&sJ�	����h����>NwMj��͙���w��cN4f���1
Mn�Ծ��U/�����ǫх0�.���rQv���H���z�@J��\�C8��8�#\�ƚ��������x�[X>��#߄�_�`Ӄ�@�� ��[x@�#X�4�@��^�e�1�t�ꬡ�̡Q].�M��o
@�e {�<G��{�m�֦�l�"$� �f�X�ȿ�a�q'�s��/�PR��o;ʝ���WG�����յ��k+�-��=�bp��O���WQ�oh�V�Q��	m�|�U���A��ă�g1\����/`��R�_O�bG+�K��w
��
}��*0�o��3.����W`�T8g�u}�g�=���g�����0j,�����cJ>8lC9���K�߯g����\�I����+G���9�����C>&�<�;����9x�yf$�+�6��x�4���R,f\����-�m��)�xV�k0�RtB��[g������N�Ƒ�s7��y�40J�}�����C|Nuj(Ų�˦�^{̾��m�o���,C�Rc�T�'�5���G@*���l'�Gj��L"矢��Sn�FI�;[�(Yv?v��H̸3X �5|�m�BY��F7���|�o�f�Q�O�9�)�����|��G�nx�1������ZL8�F�NR�<h/������)p��Q<?������B��דFh:��Z	��z�}#�.�l_���x?�5*�;�i�.��Op[�;�dS�_OF��Z<%F/�)��s ��{��	}�����eT��$� ��ɠ��=�Pc��ԛMWYO��vb40��~�K�
�r܄%��0��xa�o�"���U��B��y��:�Fwg(��T���U�P�ʝ���O"̀����Xw��U1��K�G���� h/�}`�׃o�(`�#@6������q��
;8�����ߋ~���_����
�9r���	���ܱ��>���Mi}#�K��� ��P����ş���/�7���/��W�L��m��S�~!�}v����og�&!0i}�4X��D�ǽ�;�����?�~�υ?����߇a!f!�RLA@��lۜ���][3^�����c�h���Cg)\���n��������������A��l\�7�6D^{�w\L���t�ږ����?w��������j�h΀�}o�`�
W�qV{ȼ|�k��NJ�� �������*�bHb�D��	�`����z����y����"[	c���^|h���y��Q!� �A�@�5E���r�k/���+�G[&M�v�C��e�P��3E�2�[ރ�P�Dx>f�5�֦���o����+TS�c�3���C����.Ѹ r�%p����������n���^l�=<��W�^��+�������ߪ����x��.I �}G�,�%��5�����)����l�T�/Z��\
J�`�m��c�1D��e`a ��R�yl$&�����xY��QC�w�4F#�{[|�R\��{����,����6��E)��e�P���fW܏R!������,�������r��o�`���xr%�����R��0F�Ɯ��3��z+�t>���E�x����S0UH�l�a���@��~�ZB������}���or1�z���ڻ�Ei���Ѥ�#�q6�"X���@�	�zM	�ƦA����n�C�hNU����t.�*Z��yʀ����͐x9��q�ʩ��W)�.�:���U��#�;���=?�K� k�&�/�gǤi���jRV���1�p���[�ֽ\J!X��� �*4ξ�Ж�V�����"���I���O�X��u��g2x������'��������m	���e�O�ѦX��x
�)//�>B+5i�>�&_�D���cY90��!�V��)1h�.�ߥª�V�()�o�P�Mu�ٴ
俿�*g	x�Ϟ���p19���o[�x����<�U�1�h���<6Qװ*p$�A>��u�0�tc4P3�v��wiTqs����� r�������
\��j�O�~OEX�-�.�K6�46|�E�����V j���?S��&�����r]w�07�f�����$[�{��
���΅SU<%�)�Ң�SC�\�7X�9Ђ�� _�
=6����Φ�?4��-b>F�?|1}�e-~�<'*��
|��~�
?�zFC&�E��D8�������-�
�����aH#�ɬ�I �c�L4����~��f���y�Z?�h%�?ʱ��-���ޙ{=S�%Rf_�������PTr�5�`A�+�� v>b�����I#8�Nv� v~���W�& ��i���f �6|�&�D��t���. ^h�-nBț��(EP:�m�-6J�% ���^�y�=jx�y�g���b��*�����ٮ�2h�w=SRܼ�����[�m���w�C� �/���w�b[�����t��q�E�OKl�~U��G:��}h\ҹ4d_3��$p�>�|\��mZh�;���� ���)�q���z�Q�M�x9Tu����.*�/��e�=x|�<0�r�7�k�T��Ʉ8�5�Q����H�'�/����.�����c_�	��6Q����و�m�Z�BcTq3��f��DS����ȟ�F�Q�Zɜ?ULU�x�����v}�>�.M>]%��{ۑ�Ò64���B�}�4b�g�)R�P���-�H�4�h$���0���Z�,Eh6�5�0�h�x�!�Jjߜj��lV�~ۇAN����8Q,��������c���"�s.g��F�� �L�����y�+D�xI�:F��k����0�r1��ap��דB`2mZi}��4�/�z�)�b��f�@b�4�xF�
�1��lЄ����_�Pq��\B0�v�(n���FC��ɒ3Th�x�X7M�L�Ȃ���+{�>.��/��`M�;�̡����Bfʎπ�����M��c$e���q	��Ծ��~�h6�h]�һ�zI���������Ic��	��)M���b��PN���T��X]�3�|�*NbY,1s�m���*��B������Ϋ�>�r�ma2��A>Q��L6[Tz�f�.#�|�w@��?ո��M@�Rb����	 Iu���p�S��� ��tJ�0yp�rr�!�aԈ��)�g�����9e����I�ƶ��ހ��"1t'�en�O
�]��.\��Φ~�r��a��� �a#�9�����}("���c���;��{��˅�����K��Sb�u��(���ߜ`@�!�r�X	Ĥ�c�C�3\����+�tZ�h�ˡ�Ƿ��T��$��~�W�8b��b�����I8`��(�l߄�_���z���隐tR���� }wO<õ��F^��d���b[A�y�������2�KOWZԈVP�C��
�g��m����ń�*�Ծե����+�{���
WV_���D�.n��M�oGYaʞr�q��Q��]�hQb\q.q��Aj�#�oz�4.�Y�eL�3]��D�G
�hs���_�����@p2�h[hec��h�W���|�$�ߏ��6���R\0�t� ^D�^;�)�'�&�����M���Qۄ�t��If
�W/�[np���)�ok�n�5�h���7Z$�7�4��fr��v�I�L�Yh�.&�2x��ɶ���R@�����O�Mn�&ƈ��	й4�������H�"T�3�Q�Q��lʛj,���/����c���v���寛^;���%|�uo5 Ilz�pU`��R������$F�Xڮ�rQ'�-s0.w��[���k�`4       [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bhu6bdr4i2rr7"
path="res://.godot/imported/4.png-cf0c36ab2aa3a6a557ce983302464362.ctex"
metadata={
"vram_texture": false
}
   GST2   �   �      ����               � �        $  RIFF  WEBPVP8L  /� # ��m��Ͷ}p#ְF3���v�0'�`�)���p��m��0�p����,����������J��<vݞnm[�l۶�W�B��`A�j߯_���s��j�����o�u۶�j۶����ݯk���]���@�'$�	0g�%8n#IR��vb����v
f�ʪg�%!����T��{��_T���\0�r��R\���]�P�q�t��+��Ee��e�n%g������~}��S>�;���0;�x�Y��\�y8��;�:�hYپY�)��3=�����U|�p5�#@�Lv%�T�n5�a�?�&�d�Mi��.�b>i}<I'<�p\y~]�J�#]��KR(n�G�K;Y2��O5+>��jX���g`  �����>8�� s��x:;�բ0x)p�9�{9@Jt��\dJ��sc�@d�v�W|����G@"o�l��L�\d`|��ꓐ�Q����NR_��ZoX'n`���`Qs:zhQ)=����@G FBËʢ٩�
;EcY�?T0�p!�K�1����S���f��@�  �'�)z3��wv
�x�I���Yh4$ ���b �)Z�T��Ѕp��^f���t���S`��jg(0��V򽐲tq�� �V�w_=4\и�����BUʺ����N�LQ�Y�y!>���v����j�La���۫�M�$m����#v�˗F����D�������N�/>�TE�!"���Ї����C\�4f}C|]3����,|�����J3&��q�{�scA���o�Me�vp��kLQ\и���=/�>��jy�j����-���" �}�(fp��P�X[_�j ��h
��V��=�Ξ��)�����GPZ6��\{l�G���^��`Y�@<j�׏��pv�ֹ�9
h�A�1̒����m2J{L�F�l�`� �!z��]�4(���f(��'�F�f�����PTVmb�������7y�|�RC�Wi�]���t��pa�ƃ��ὥJ;��h}�p��F4�r�����r�TVㆷ8~�0٤E��a��������.��-�[3+�)��T��'���d\@Ch�DBY�p �V�%�тc��*ҭ�� 7"X.�(hL����l����,G���5\������U2���ڨ�0��T㘇��~�
�{�c��������׽�:��+<O���ޑ>E5fx�>؝�g���� Ah��6�ȟ>3�3�]���r�K����y��ҹf����
���\�ECd�;����_q���?�s���l�]87N���Cq��1�հ����Mz��G��}t�����@>��l�������qy�jXV3J����wzv/2BCE�)u皕w7�h>`���X�L�p�7�s�Eݹ�΅sS��d�ƪ��J[�&�]4\�?��J���HHٸ�R��{���� F�N�����1C0�8	��1jx�/j���&�/2x~%R�z8�xؽX��5�	b�r�fC[���/�c8��w_"�?��{`_T����Ѳ`v��˼��ܯ���1���%��F�cLAc���������c ,&t���6�9w�FZJp�
���~Hۿ[)�`xa�ɱC�ۜ8^!7i�xQt���?.+�d�Iw	� ~ظR���x�5"��5����c�mAkB�������{�a��4�[�
�#�%���?x���a�2� T�u��NI}Q4'���J,��^\��Z(�;;(�7Qq����p����QCF��1��)������H��cT-�~� ��է�۵�ı-n�~\h��M{Eͷ�^0xr|���]v"��*�W)�!�r~CA���w�F��hc>}Zp�XT�c����{墻^ԌR.��n���j��fM{:)xe��.�ڥ;��Y�g��U��/?n�Bx �=��Zo*���w�/�:.�Z�����,}�?f}�s�gf9�o���!�� Z"Ɗ�Q|�{n}ڿ[q�����E��}u����[�w�G�����)h�>��Bp#�zQ�u��G����U�u�������o�}��K����V�wJ@�?J�?,��� f}>{j�ˍ�4wz�������>���3W��[��DG �=�*V}�j��	�g���x��	{�����i,�����Q�����'%�	MU5�ꡑߜvm��+��l6Y����d�uT�_qKU�?�$b<�܇���K�={��>��H&<��CQؾYS�Z6��AQc<zh	EM_�\�Te�����J�RV����Sӫ3XT���W��iQ�}�L_)a%S,�������ȌI�rљJQs:�_�$R<����
y�f�uh�T�"�`~�� �tn��� h�MVmV���3���TV��/���x�Rs�7=	���������E�p����ZccQ�������AɊ�xL��O���\wi�Ǥ3���� �D
^�����J~s|o�d�{�q����rp����XV�A*ㅧ�%�q�����O�R��߿DJ�O�mϛmϛ3�E2c6��V������훵?Hg����!L��K���yQ�}[����XL�s���ɤ�9��&�28����Qy�JNc�}] �M����AΊ�/QN�R�g���L�����Z߅����l(�'�}�5��%����1>.�~��FQs�VԈ�)�[4�J��{��:]��s����R�K���s<B"ņǃ�	ee�v����4xJ�����?��d
�d�%�� �9�-!��ڃŤq���aǨ�l<x�8n:w��]�?��ڥ��>�A�λpP�?<���<~t �Q�ų��5���F8N!�#��}��;��Fk��Y2?�g�<VԚ| �:.�S(X6��/Ȑ���F���|i�����(l�W��N��+˝ �c����v�s������U � ��D�DJ���@	�f�A�q�R<e���NT|��˽��9��N�1��S�E��`���L���V�fTg�MI{Թ�h�V}Q��M]�ʊ"c��d�[����GG���!�ǘ?;)�Y�W/��+���V��2i��p��yV���.�HK���䂡�L��-����E�Hf��^��\?B��>�uK���PTCO���p���)�yi�W����sug��3�)�g�;<{vk(��{���<x���y���>�@�/�������VF�> 5b乥Lx�Kg��q��z���iof����ڎ��Q���y^�xx}���SO5��'}GLp��m��h)�o���vN���C�����N��N�w���RՊ�N�zޱ��=1����~�[Ҋ�q�S󢇲q���4}�[��O��_��`2��v����o�2�?)��U1����͗�5��Ck�Eˬ�?&b�����ȋ����ź~�;�����-&;q�ɪ�2�}k��n�uy��ӷ�".܍e=vx�(m��
�#�e�N%Z������P��	�i�{vkjeZ_F&�/H�_���f��D������c�����9���7'�iwgzmK'UQ�w��I��<�-�:���P���6�g#��j�V�iw�����yA�^�>����᭾�a�nWz�����؜[�4��&�W�._���UV>YY�p���n���ʳ��=���.n�5��^��¹	�,R1�&c`$c��}����E�(���ƍ��[�xJɔ�:_ �G���
Ū�5/k�Y2�b��Q$��w6L��Pm֘;=c>�����h�g'ԏ�TV�O���{CQ!|pX�6&��w�x��h~���g��l:�ƽ�]����6Q�zل��P6>�c&��PPԜ`�T,��Ag���FY!��.�Y^�xL��i���F7���X� �=Z�V�O?�1`����D�b���՞�tcYwi��{φ��S �W5��_c1QuT1��2:x\�Ը>>.���0坡��ɯ��YD�ʁ�
��$S�{8(��\�Z�p���l>`�U�Bʂ���~�ۜ�N�ؓC��+�=W��EM�ѱ�f�on��>fOϢ�����dҽ���U�z�e�Uˑ,��ܑ4���E�sk�Z��>ʺ{�1��A��vm��<�y~�qO	��L��.%���L�6�H-�Cya��Sp�Ti8d#+�/����-����1���YX�g�P>�L���1������d���ڥFk���n�����K��G,�%�S(�v+;>���L ����Eǝ��������[|w˜�l��.�}̟����3���Sd@}Q�Y��� �ŭ����Zc5l�Pp#�=+gOM&,���r���"�y��o�v�O!ݪw��Ρڬ3y�g��ê�6ב��_T0x�4h�UU1�ZJ�����"TU�8�����܍���+�$�W(y��m����Yy~e�K� h��~�Ag`�y�R�ռ����R��fY�����Z����]=[��Tׇ�6��zV�?)a�VՀ��E�@��t��ѭ=&�XL3�������K�^6uқ�����k�����O0ش�"�ٮ�z�Y6凞=���`�]��~�K#)���x���/΍�z��f���Ʋ&��*�9���r����W R|��`��wz�ymd������~�i��k��ѳ;4�̷i�-�s��YK����Ai,���[g���h��nɳ��C,&�|��{��M R����7}���2�+Du�3�}������u�~8��wR�R��w�7�w+%�*�f'L}�mqk4�;='S�
���k�@�7ҧ��i,��ÛAy��V%�D��ED�ˡ����F�K�'0)�����z��1 6���,G�y�z�z���{{и�;4��mi^�J
`���1֝k�n�w�1�;n۫=�R(��jq�v������_�B_L3?�6L���I�K<&�+�pvR	���
��N��&=���זn���_(������9���O}��&-o�'ؗ��Yy�eM�o��BV�?=�c:��vm�V(�'g���F�r3]�d&2�r�p�jҭ���� �:�kEM�TV�^�u����*!7�DJU����Y�=�D�e������{���q����~*�_p������:T�����|�hV��XJ���.��H��z�`"�eݽ3hto�ْ���j�+����|��O���}��/��#C�.�S�cv�^�o�����ア���t_&��7�
|�ܽYi��Yy�%bP\�4���7���>-��M�O�]��Y���?�����.�q��Vا��P�L��f'=�֦���,���Ioҥ�>~h�ٮXY<;�)cn�	/��b�|w�7~�ܛ�_��Gz��j����o�@Q�Xm�lW�ټ��B�v��)�9wj:��0O�/��k��Xqq�#ӽ��Ə?Յe���l���x��Rwi�:b�=9k����+�8��7x��u�i-1xN.����(�k�-���q��(���^���8����%�E4򹾬�e7�����p"���ҹ�{e�7�H>�l֎ep��m��P>��i��+�G� �{��p~j�	��ɯO
��^Z�Ds�p���gG�7�Bo�?܆�)j��-V,ƃ77��O�v
��&L��{���z8��q����><<�bm]o��e^Y��T7�>~�����i��q�58le�p��sR�s���[��E=��a2l�H� K���� y�EĹC��2�v�W�~¿���DJ��S����
9�6�ج�tw�������W��g��6?�ۤ����������̙��1`Z��W�����-&&�Ϸ�C
Xn�50%n��1�/a�D��M%Z�N[;B���p~���T�{P1�&S�l{�9X�p�S`�����_���F��e�Qw�^a�_=ګ�d�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://ryvjtv6alhvl"
path="res://.godot/imported/5.png-d8eabfb4819dbc68a3ed4acdc14b975c.ctex"
metadata={
"vram_texture": false
}
    GST2   �   f      ����               � f        $  RIFF  WEBPVP8L  /�@ ��m�ֶ��}[�mɒ�`�*%efJ�������)���ܤ�0���u.�O0}�#Kƈt�Ǒ��ڶ�ٶm��m�	�bw6�����n�Vgy�������m�il���63��;��LI:��'�$3���,i�_��6�$��7�B֙���^(rt�� �@@�򂎮�Q'I/��h݀��0H`c!�B(̎�4�A�K��
 c��C���>8�m^�^P2a4� �4Ct H ��k�Ǘ&�$� *��f��y��/nY��C�FAE� ��
< �!�[��Mb����k>�TT
p��G��ޚy�Q�K��<`p0l�T���9ψ|X�aA�fx�`?R��m����G:� ������{�@��Z�:�s�Z�Q ���|g����C�����A� ��
�0��g@1'3�c P��l`cx�������y.���u�z��l!0t<��N �Ό,�T�_� i��	=z��&�8��-Q� �(��i��n_� �[k��������}"� ~k��5�'� n3���,���K�5����Pl`�T@z��-BRzd�P�6v���oB*8"Š�����	�z��:�sv_[J)�D,�����8i$`e�B�	A�mˎʏ��Ɨ��N��#P<Bh< .2 +��Ɣ�$��2a#l��	(�Qg���>�F��$�\?�FM�h��Vp��yPe ?��ߟ+���/����;4��N�⧼��KH���۾�ܭ��@�^ `x m��߿2���;ҡKw/�Ӧ>�ΑC�ƖHQ|:���\^� �d� TT����է�^�Mc+]S��u�d\� �p0� �f(�Q�N�5K�׳;_��
�����vGr���a"l�-�(�� ;��v��x�Y���M�v�\9V!�@�BkX$���oNt}�ӯ��Ni�d�W����n��I�5�'�
,�?�ft����]��<���B3��Y�K�ϮYj�)��΂ �GK�����ugf�'	���
q/��7(�#l�6(&���cո�B���gF� P��ѵ��.E���A� ��øbn�²���}��@:�.EH���
ւ�BP�❬�m\�PY�����`tꜝ3)6\:A_p$<@~G=���^��{.dQ\���k�_����@1=<��$�`�p�2.�e�d
 &�'����/�/B(��*�!�oYV���ޡWel��7�a�x��CęU�(�4<�����TW��įM�􂒲�e������3�&��Ԫ��vM�R�+e��_�<s:�8T�h������2e4���N ��9�0���d����L:A����XP�"b�V��S�g�0u<E�q��&�Lؚ�����5ak�޸�;Y_�DQ�Gp@F΃sn��� �w�ԹYش#������H�-ᥤN�T}��2b��YwQg\��\'��S�� �(�`6j �n�k�x�ud���v������e����G�ܭ�K�������gy�)�EO��G?[W�,({~�k��x�O��O,�^rUZ������gܴ�������` C����&
 �iz����[<X����o����V��'AI��u.������{+_�k�3���g%�$+�8 >Ӂ(�����+�"̙�u�4Ua\���@�o�/������@����D^��3>������}�?��3��,�^�T������0|x$���q�{P�����iGRò�������?������5�ڤuz
 �X��MG�0�D�:f��\�[�r��/fYG�p͗�u�������n
A��G0���,�����*d��Ʊ�w)�S|�RtPEW�}Ċ˜�1�rϧ:i�9��N�oZSiH��ۖ��NE��.���V��걄k������5s)b㢧Qm���B�����a���\g���'����tL�3��z�H�ӂ��)�����`@ftݿ��̛��X?�-4;�/9H���UP�K�~,q�?�R�U����u�:9����NR�����;�"Rml�ޮB����8�=�����_I�������<�j�1\���-�O/1p�P��4�{����\���#���u'+� \̙n�M��84������~X2�^���ɋ�F���]'ʑM���Eۤg��.e�Y��DU�ޥ������C�����YqjW�oE+��Bs��9�J����:��_߳��U��5;��/��s[������3�~\=�������v�a¸b�z��N;d�-LMQg��u�������]�[���( P���Eo�iQxuKz��fϺ���K���#<,��^���6;�ĆX|zty5D�`������BnǗ���خ�M�����:��^�o:� D�ʠ�E�V���#����K�h`iy�9���k��қ����3� qp�r�vu����Ueo@f|=8�(�
;�3�c�	����c��+�����api�"�G��e����Uo
9����������jkV���Ȏ��[
+�pқ�A�z��^ܲPŪj�XASֺ��s@��=͈�.��z�F��J�|S�e�7ag:d�
-��{�$���覑J1'Ç����&� ����
���N`���\�|�,Z|�0����MB��6"�	6m�j�wBQ ao�i��a��bJxA���c-����$�si0d��[������ӂI�Tm,D�ɲr����zq�p��f�h�B���r�+�n�&��p|Sk����M���Lau�ǝ w��;�,8��Ƚs�^��y��,��g�>�:tͶ���5�:��o�ǧ:Iz���m�(u~�G
�Ä��N�^�s�\��o�uz���W��(o��� �:���N��	��}�%w�б�|q'��^xh�Įqd�l�Q�~*�N�Ŝl��~�tܹ�N���^w���;#Π{u���FǏ��ۦI�.�r�|�a�ӂ^��k���&̛���6.zM��x�T��2�Lh�9_�3�J>�k���m�,����hC��|�HA��n�Â��G��ȮK	��s�Ž!��R��Ƞ�K�p=�f�VU�eqm9	/gw���P��׸~6./9U(H�zgh΀� H0}<�Y��ҸٮA���X+�1x�P�e��qfM�+�� ����7���B�z^���~���%���׌SH�����-ˉ�	�ˁ������7��jc�<�e��7`���m�|PPY�ۧO����hCaz������զ���ĶFSo͜�ظNK�.lM��n�����84�O�&Ȣۗ7��Qk���C���i,�.E����.�Bu������A޲��$�
��;�NQZ'�D�s�	����ٮA��Q�:��j�Y,�'g�	oV�='���PՎe���a(>�(w���͋�����
���\
=*,��q>�/YN|Y��r�TUml�|��h���Ók�yfN���uE5H �x�T�3ƣ����#�u�P�:�}��Ό�ٱG;.�δ��ﯕ�b��FTTܱ�%��f���@v|�5a���hKܳ�N����c�j�xd���b�q-;�
ݺ[�q��OQA�)�9�T�J��n@�|��8������ل�Q�:��ZY�(J9��^v,;� J�-�[ 8�ʡ�c)��]v�ut�l�zx��co��r@��w��&�?[����AP`��������]D9��%��ڤ'Ɵ��J	bP�Û�Ƙ)�I���o��ܸ6�B��
;Ynː���{W-ƮUk̄bR!7�j���q,�A4Enڤ��*5%JlZ�̨w��s�У�5��w]f�Ǩ3q'ԉ8�/_-��_4[���F����k����fU5���9H察�$��.����{�̟�eP����I/�w�Ӣ`����K��
�s&#���X
@�BNrU[���پ�*������ˊr��A �
$��k|wNE0�:�-�=u��w=��H^�� |���/��^���I��X;��m�K��l,����p�T��l����;�4���%qת�v~_Y[ǣ�&���ڮ�C���*>�9Z���쀔0T��Κ�蒡o��T��Kf��)ݹ�����Y�=��o � �60�x���uf�l����K<SfOG
;GI��������@������t�TZa�`M�C+{vͲo�������Z+����Go��$x*�=|XB�l�0|WY_�<H��Ot��<��? A�҄���^wy_J-O�j�"l�U�T�]vT��]�    [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://df7jfwb30sibi"
path="res://.godot/imported/6.png-66d5265b13364699fc1651f14737e8e3.ctex"
metadata={
"vram_texture": false
}
   GST2   �   i      ����               � i          RIFF  WEBPVP8L�  /�  �wk�ֶٶͲ-�Ȃ8\'efnOJ�23333�L���YfftRٖ�_�S���[�	�l۶[۶�1qY�PP`��{Y�%w��J]���vk�#ٶ"I:�̰&�Y�����L���^�!J���gW3��A�oTZ�Q�uI/	" Ub p��'��6h��P�.�P���2P��w�w;h�Q@�i�@8���ǲ�GBX<�眐	T��l@oW�  q�� D���?��@��?ϕ�� �"`�������	TX�;[d�`	� �0~�Txd��_0pY�l��Q�r+������$P�10 X3T�Ste1�t�$P�o���
�N� �i�'M���sو�q��� � ��N�@�O�ɴ� ��L@�����g�	�@��3��ޠ� Xp���a������;C`���W@�`ǑD�,��/�9���4�Q�g�*T0�*?��bT�ք�)q8��|�@���CC(	<��l�;Py�d�("�&b-� z�^*8o;UA�ThL���l]87�D�[�-��,��AnW9���̟���|$x��3%m���i-�3��<)�� &��\�q���/�-��1��`�C�s��^C�[�u�=�� H���A ~�p�����:/	���� ���YEA��( ��Y�9�b @��#��fg��~�˂�PA��x�����}�;a��̸�Zq� �DP"HP��Ǔ&c���uEa	� ` �dŢ;�7u�z~����;Q�U�r����q�;3g:� ��D� . #��׆�0��\��� 8�`�Fd�Ќ�ut޴v\�,��;P��aie���6e�O��7��5JȐRX۠���i  ��A�@����@�uՑ��P=��h�f��)��P�ax\gD��bNl�mP@�A� X{Ч�"6�I�_��sm���8�AA����:��X�\����O����?������q�ԡ�\u֎�ה Bx��af=t�� P����^��;3��a�������u^�ǵ��ûΓD�V��0� �w,`9��G�������ѵ��a�=�]!}�Y6"�������e�T�L����^��D* �N�T{¨�$�al��@@�n�5���#;��6�T(�������&�EB�3��0���*����i��zXg�ȷɟ(�Տ��ESgfL��0 �?�~yh9�­�� ���8�+��$��JBȃ�!���Q����C�33'�x$��F^e��� ai{�(8V a�~�-_�uv�x-+B� @�lA��P��4(�g��Q��ǻ����tǉ�
d�\����<��5���Me�6.Pa���2�2`�� �����L��"���J��p���C������E���u�V�EA�>�B+v�c��׭��̜.	@� ���`�r� 8�UH��l��ދ�80�H6,^��W��-mT�9�;��ř�˻*�@�����I�A����6Y�Qƺ�(�`�uf�l�@�)��T@:]6** ʆ�!BvcU��`
5����@e�xQd����9ٸ�I���s8�q�QTE^�"���I:�T@�)´ɒu�^Msg�;�sB�Ɇ�MEL� �����I�!�0ީr�]o���06�����ҺW�Y��R0�  �0-���I���~Ѹ��S5)����a��xj$��$�!n<���j�V�C�y:��~ygͫ/|��,��Cݙ0~�� C" "�d��
"03�,_*�5�*@��?]��o�^�ѻ�xPe���9���	�K뺧��Ç!̝΍������������ٚW���uf�j���q`���RX(��^���:�d~�	�^����o���P=�Y��R�� r��Y^2�bq�r���t�[�h|5�"@���A�� ۏ�8���2 y����̈́�(�V�g�Y�eS�EStu1�tB�:;����;9���)/���8�8W}{�
@l{UT��e�i!k�#�C�V0��1Yh�ll��ta������go�( �A��NOƏ��v�ʻe�3&K^_ee1�P��׊��٬ ���E�Q8-Y�U�l��Ѥ�_���KiUa��s��q�u�O@<��b?���<��im��aB�ȿh���)�?�_��{X�Cx�ځ�݄�����GN͞�����3��%Q|�d܃��*�M�a�|ʫP�t+Sa�D%ъ�_��!s{7�.�=s��qԷ�W�T���жA7|yh�G����E�cO�dy5w���c�ݱ�[�JH���NO�6YZ�a�q��%� ���{���G��>��Wvy´�uv\QL.TG��)�ul�tV�O�Ɇ�h��a�q�A�j�nͨ.���(�TyB�`��� �{��t�Ca�˂h�+�l�%Ҡ�nBu2����{�	�ȿ�ឯr`7�h�d;��i��Srݯ2L�篥�ˊ{�	����͐0$��~�0q<o���� &�v�(H���U0�*��ц�ȟ�����������;�8�-�āŃ:��$|>\�� �h\��|�� �Y��P�˷��F8�tfU1چt��s����#��O�ˆϵ{��aX��Z:���.�~��aH
kc��12�M�\�ٙ^�aB��?�Y��ӱ]�trN�<�6t���U� ����EX���Nx������.Z[6�8^6v�`�P2'������]�@���[�
#���~�]�ӅI��W���C�j&�@��#�N�_�[Sg�d��].L-oZ�!�dy1�B��_��8Z:3q�P�F�ɲb��O��`�UN�ZK�6�UV��!�Y�y'�@:��A�0Z�Ag.eU�=���1�&PyiݧO[�g�K�ZCV��C����Q�*h���Ѱ����A��Ӂ^�y�����Ԓh�O�+YC�
|{l�q�Y�Y�%J���N=�N�4�R"�Pl/5�O�ɚb�	
s��}Ђ���������9ٸe���k3�<td���I	�7�[��s�^t���N?N컂�ܾ�6�xZ�\���ˁ����զ�h	^�~97p�N�$׍GA��/��%���uf�l��kzݩr�Ik@�ta���Uk��.kb�k=��P��vR�����a�r+lOM��ՍU�|�o���m���byٸ��eB��lr��!��������$�Z�+;,��;���uc�	��3�X$-ά]��h�O�Fp`��h*О�n9� \j�g�o�hЄ�ɵ{QV٥:�v�����r/*�`�������d����<W8|�Y�ك��y��}���:^�'�-���̝��2�a��i�L��a����i�?ϕ%�;�7F�4�f��S�� <i2g�U�m�;�C��w��K�l�3�Uŗ	}{�v<�3E�
�G�	�I�찠w��X�p�mgǍV:�WN_��b��p��۹��^kO5��Wٲ�����l0��s��~4a����.^��Ȼ²bb:�����5�Zg-�K��,̚.9'���r1i���ǹ�􈙓م��u�ʹ��pj/���a3s2'�t`�$�L��`�p{�Z�[$ä�����ލ�=HG>�X@概�Iڻ|'�,��l�<u�tt��7e}�:&ބ���u��h�����#���N����g����׭�0~8�+=�c�UŨ�a��K�Wٹt0�T{��l]� 
?���	+h^��������,��+�	���>n/��q�Q$�h�����n���**
�%7S\�^��ө)�S�IGv����:Y,����aO+u��^&�n���[Y���ziߦن�L-&TǾ�5~+�"?9��v}�B�SG�m���l�&g�%�	��{���>�$�h��ɜu&gF6F��C�����}��i��qdլ^L
H�]*\�7d�%����Hւ�]��o�m�יKYF[�<Z�q,+&7�̝�� 2�Y&=��C]�*�o:�����M�(D�.,����L�        [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://djhsvlu33lltn"
path="res://.godot/imported/7.png-e72809ab7ccd112ddfd11a481f421ba8.ctex"
metadata={
"vram_texture": false
}
   GST2   @  @     ����               @@       �-  RIFF�-  WEBPVP8L�-  /?Ə�m�F��_;""&��k��i#���������'���I�,�S�	�-��.����j�<����:t��C	2l�� C�Tk%LE""�� A��� ��IC+a�A�.�ʰء�d���r������]�����ύ�����r>�����{vc�e��#�1�cD�QG����h����RQ��O�9*�"cT�8*�T�z�1��"��>���r��r�&@nmm���]��g��)% ��@0�{�����+K���zZ7� �f��9q' ��������������������������������������G���$f�|�A~��6h�7�o�Aj���lnAj�K*ټ�Ԇ��6���0h�*�_״����P;X�������?�ds	R�M��lVA��n�ݜ���;�P��������J6 ��ʿ��?�d3	Z����֛G�R�~��*�y�}��תJ6g �1ʿ'd�Rk�6��Ѷ��(8F�yo9B��
�7��jҝ<�y����d�R�}��M��jA�bB%�#�Z;?������/��:T��'H���x�Q�6W ����xRS?eW	�U���MTIܦ��o� Q1���H���H/ФJpO�J6C��4闼/Z�e	�(n~@j�Iw�&��l�d�R���,�C��i��)�l.@j��'�H�_,�]*٬����G[�{Xq��)nN@j��tO�j~���K�͕Hm�ɢ�4�߻-JTM�d�'���~K���D�G�W�� }Nz����I��F���ҽ=����`	�V2����U�E����C�UZ��Oj=<&�T�L�'zV2�Sr��x��:A��J�?�}L��5��/�'����6K5�ҏ4���D��J�|R��)���c����]��O�����Xu�_)������ /k�8_q��+�Im��4�?�$��JF{R�.����/D��_ɐOc_�~Ū?�UK�o4�Im�A^��1��`	vV2ғ�<�%�k���$��J�yR�Et���*��V2���E�S4��JpI�XOj�H�?�7*��J�xR[@��5��Z�����6ȫ�j͟�5"�W2�S�;��4��KpY�Q����~ܛ�d��		�U2���"�m<����W6H�����Ԇ�����)W���Jx��Bz��O�L	�j1���~�Oz۟�F���@%�:��S�~��S��m%�e%�:��:�N����+�i���4�¯Kp]��NjI��&a��%8TɈNj�I��KͿ�W��`E%�9��P�n�l*o)��Juj� ��f�y�7��I��0�g��&�����B!c9��$���5��G�(�G���6Z9�I�i��H٘J�qRk����lj�c	nkS�`N�Q��y�&g��%8�0���*�=���>n'	VW2���8�7k6ŷX�xo|%#8��s��\ͦ�<	~о�a���ݲMԲ�!�	�Q��֐��	ͦ�I�H���ћ�&�$n�l�o� Q1�����:���|ͦ�	~ұ���S�_��M���$�i���֑��)ͦ�����+�Im�J��vͦ��+�I��{�j6�Ip_�J�n�ΐ~ي�GKpVq�&���{xF�a��=%�TɈMjST�-�s͇㿰(���J�kR���Ś�oI�P�Jm�>#=Ɗ��J�c6�m&��s����-��J�jR���,�G�az�E���W2R�Zw�H/�|�^*�c=*�i���������S�Im+�>^�|ؾh_	>�d�&���ɢj>|dK��Y��Ѥ��S��5�WH�L�JjJΓ�`ՇҪ%��4N��'�K����2)�V��Lj�U�iw�\�3G
�T2:�Zu�g�|���N�J�hJ�&ݥ���	��x�&���˽r��A�dd&���s<�~�%	�U2.�Zϣ�B�ya@%�3M}K�_'{�)\T36��N҃}����&��J�dR�O��a6���$XPɈLj������yeP%�25.���Y+�&�wjFeR�C�1oX3����d4&���[{H�v�?l#��J�bR�>�F���V�ސJd��Lz�fmy�W4�Im�'�e��OJ���q�Ԗ�n��f��s$XZ�(LjC�G�D���N�a�Ŵp��L�Z�k\�r$&����њd��$8X�Lj�H��������`y%�/���6��f�z�HوJaj]'�5k�oHpC�Lj�H���>#�a�B�^R[A��_iֲ���++yIm�rt�fm{�H��J�_Z�Ez�f��w%��u%�.)!��w�y��9	�*�����լ}���*sIm�r�}�Z�fd�%���Y�+�]�*v)�_�GX�FZ��%8�0��jҝ<�Y+?ag	�T2ڒ�x��h�ηZ���P�XKj��@z�f-}�?�PɀK'I��lM��/JpJq�%����xJ��~ʮ��d�%��*ɂ�4k��-HTL�d�%��~"�@���P�{:U2�Rt��K޷[�e	�(�����tw�Ѭş��+aIm�J��N�����B�bJ%�+�uv��"�Z�b	�R� K�Yң�X��8F���XR�D��g5k���%��J�VR���,�[���ǢD՟T2��ZW�H��fm��t�dx���I��b���8	��ht%�-�{{^���>l�dT%��ɢ{5k�Z���YɘJj==!�L��\��zV2�Rr��x���N��ҸJj���E���%�K�I%�)��RM��#�z��>"Q5��є�z{Fz�f��m	���dH��+ғ�ZG���%�JiD%�m�xY��|Łl�d$%�9�K�Ӭ/bI�������W]��z�/D��_�`Jߐ�lպc�W%�Vӱ���3��^Ӭ?_w�;+CIm��5��,I0����x]�Y�^%���J�Qj\$=E�^=U�KjFQR�Mz�׭[��1	�k%�'���tki֯�Z������6ȫ�j�z��z�+@���i����\�l�$�����u�[>!��J�MR[L��O5��Gl�`I%�&�Q�����?�7����殐��Y�)�U-FNR�O�Io[m�)	T2b��R�~�Y�¶,�d�$���D�k���ykx%�&-���?Ь��.�u�c&�$=�F먍��P%c%�-'��/5��_�^�����6R9�A���Q�lT%�%��$=K��>[�[Z���Tp��3ޱ�z�g%8�P�(Ij+Iw�k���Q;J�Q%c$��V�nҬǿ/R6����ڸM�M���	�h[�0I�1��[�N[��IpLa�$�U�;z\�^�N��dt$�q�%n֬�o� ���J�FRk�.鹚��y��}%$'H��l]��(	Nj0>�ڿ"�œ���Sv�`m%�"�MPIܪY��fA�bb%�"�u�#�������c%C#E�H��=3��}I�ӊ##��'��ӚY�o�.���dD$�?RIܡ��aA�br%�!�ur��Bͬ�"	��\ɠH��/[13Xq�g�DR�H��g4��g�)��J�BR��C��.�,�n�U�*	I�����f��$x�k%�!E��cŌaű|��hHj�I��f����%�R�(Hj�U�E�hf��Z���Q�Hj=<&�T3��L�'zT2��ߑ��>0�����SIm+�>^��&_��W2���L�d�5���R�jV%�����r���
	��]�H����a�:I�/�F@R�5��^��2_v��*�Hm�j�?��6�$��J�=R룎�ۚY�wD���d𣱯I�b��c��|���Gj;H�f����$�QɘGjsI���Y���$�WɈGj�=��B3�R��{4�-�W���4�HpQͨGj�H�fV��C%�]�hGjH��fv���$XP�XGj����f�z��+�*�q��T�l�4	�S3ޑ�ҏyÌ�M�`o%��-"��ÚY�Om���T2ʑ�﨏���^��7����f.����Ş!��G:R�G�	o�ɼ��d�#�%�<�����	�V2���0���B��^��r�p��Pn�}	�i9Ƒ��U�*8&��J�6R[F�ЌPri;	�W2���o��BٽA�ld%��n�J�Y�T;���ߐ��M����HpX��Q��V�n�P~m	VV2���(��F��$R6�����n���)�ߔ�6�h�Tp��s�5#Z�y	�*�j��+�=��?fG	VU2����������$�W�XFjm�!=G3K>W���U2�Qp���fJˎ����xFjkHw��f����%XS�8Fj�O�Sͬ�V*�H��H��̞ϗ�G*�h�$�Q�͠��E	N)�d���tWOif�O�M�S�Fj�T��kf�����I��_���O�O3��P�{:U2�Qt��K�7�Z�e	�(�a���tw��̮���+�Hm�J��;5��,J|�Ǖ�\���ҋ5��%x�K%�EgI��bƵ�	>S�Hm鞞�̺����+�Hm�j��n����U�+�H��G��hf�J�X�J.���8+fb+�����-R�B���5���#��J�+R���,�W3+��E�����V�����4���%x�W%C%�IO�j���D	��҈EjI���4����/�'��T�6K5�ҏ4����D��J�)R����Y��%�ӧ�����HO�j��+|��XEj�I�f���%�^�EjN��'�Y�O,I0��������������s�+�h�ғ��ѭ���j:J��N҃���տ�	vU2:��|�%hf�Z�`~%c��2�J3˿J䥁�PԸHz�f���ԌO����P����c�d\"���[{H3��6��JF%R�>�F3��F���J�&j|G�w4���%����Dj{I?�Ms��|B�}��H���t��j惏� ��J�#R�>��f^x��k�WɠDWI���ϔ�c��'����}J���E���t��k承���*�Hm�7������D�Q�pD��_���!��W;��� =�Fs����P%��-'��/5��_�^���A�6R9�A3��Q�lT%��$=K3�<[�[Z�C�Tp����1�x��$��
��?��/Hw��f^��%���ч�F+G7i��)S��Cjm�&��f�y�w��d ����-�k,;B��
���&�����v�`u%����>Yp�f�y����W2�Z;wI���?ϓ��+z(8Az�es�eGIpR����֒��I�<�)�J�����&�$n��G�������7���O�h�H𓎕:�"����M��%	N+�9���t7Ok槿��*kHm�J���<�N[HT������:�Oz�f�z��u�d�����V�YV-�Y�ц�6���ͼ�Y{J���Q�Ԧ��,�K3�ۢDմJ�R��!�4��K$x�[%}Nz�s��J���m&��������`K%��MWMݣ���kQ�jF%�����R���2	��Y�C�9��}`���	�^i�!��@��5���+�Ǖ�,�6S5Y�#�|�G����UɸBj�<%�\3�B�gzW2�Pr��D��>�N��+���Զ��e���J�*SH��H�ܧ��gI�9��(��G]�m�|�;"u�V2���פ_�jN��d	��dT!��yU3/~���d4!�y�K��̏��%	�U2��� /�+5��+E^PɀBSߒ~U3_>E��j�R�Ez��͙^w��+GHm�V�̛����d!�A^EWk���X�A�%����4���$�N�HBj{H?�s�7}\���� ���tk��?�A�ŕ��6D}t�f^�]�z�[� BsWH��̯ϐ���c��5�'�m���OJ�����Ԗ�n��f��s$XZ��Ajü���̷�ycx%�-]#��f��u	~���AjI���k��$8XɨAj�H��K������`y%c���6��f~�H��Jj� ��f>~�7�7H��0�g�֜����7
�����t����m	VV2Z��(�����o)]ɐAk�H���ӿ)�mm**H��(��k����S/Hm�������*'Hm�wɂ�5���-H�3��Q��ںCz�f�~�w��d���8����)�	����֐��	�<�I�H�����&�$n����'*H��I����ϗ�G*$h�$��T�_6I�)�1��֑.�L���-�`}%c�MRI��j�-T��@j��#=%���/�=�*(�[�-��|+�,��с�6�.�J����C����
�6E%��m���eQ⃩��	���ҋ��[<ԥ�����H���	Xq��)����{yN�>g/	6W2��4�d�ݚ��=%��W2�Zw�H/�L/���	4��qVL>p��ш@j[I��fJ��}$�Z�H@j3T�E?�LhQ�jf%� ����2���r	��U�`@�y����:Q�Jc�}B���4�× ��+Hm�j�?�L�#U�+H��g��P3M��u�T2P��IVMV}E��5Hm;�^�L_u�;*���6�t�O4���-I0���Oj�<��B3e����W2 ��7�˪Iê�J����v��5ʹ�u�H���~Oj�I�<��:>h+	T��Im���U���?yi`%]��HO�L!O�����Oj�I��I�>&��Jz<�-$��C�i�ö�`Q%�������L%���;�tz��Lz�f:y��5�󤶏��2�x�'$�WI_'�Ť�+͔�$XRIO'����j��׉�6���NWI��L-�&�5-z;� ���&}J���rR�%�~��^�¶,�����po��5S�5���N��_�L3�!������n���o}Z������
���J3����%XQI�&��W�n�L7o)UI����gi��gKpK�NJGH?���w}N��
��lR��tG�j����Q�_UүIm�r�}����"ec*�դ��m�s4��s$��m%]��c���l��	�+�lR[M���5S�'�,��Jz4���>Yp�f�O-H�7���Lj��@z�f*z�?h_I����߰l2��(	NjЧIm-�.��LG����*�ˤ6Q%Yp�fJz���I��dR��'�4�ҿ'�O:Vҝ):M�%��K�V�ͤ��t7��LMcw	6TҋIm�J�����N[HTL���Zg�I/�LQ/���Εtd�Βm�$e���U�Ǥ��tO�j����S�M��_R��C��_h��w[���VI�%���~K3]�D�G�W҅i�s�c����8N��5�����to�k����[�-��\R��j��^ʹ�^�U3*鷤��c��R3u�L�'zV�y)9Gz�L^V� �y��Kj���E���%�I�+鳤6K5�ҏ4S��R�jV%=��zyFz�f{������Rr��D�&2�N��+�^Kj�H�f*��%�^Io%�9�K��LgbI�9��UR�.��fJ��:}+�4�5��VMjV�,�7��WR�Az�W5���,��J�)��#]r�fj��%	�W�KIm�ѕ���#�J�*5.�����"�E5=��v��5����P	vW�CIm�V�Ls��+韤6ȫ�j�T��z�*�����4�t��H�>Jj{I?�M�7}\����MR[D���j��?�A�ŕ�LR�>�V3���H���tO��Bz�f�{�W5�����6�y�'%�_I�$����\3���,��O��0���N3�^��tLZ�F�5�4��\W�/I� �a6�mt�+鏤��t;��L�i;	�W�Im�rt�f:|�H��J�$�n��G�)�Y�ԪG�R�a����I�;>+��Bz"��$���5��G� �?����h��&���&��ѕ�BRk�6�75��oJp[�J�"GI?g�i��%8��Im��L����+遤6λd�͚i�-$�WI�#�v��*�+�]�*��o�#-�,-;R�
}��֐��	�t�I�H����GjT��j�̷Y���XI�#�~$=_3m��%�Q�J�E�H��=��|Q�S����֑��i���i�I���^Gj�T��k��wX���\I�#�N�^��B_$�}�*�x�!������g��m$��3�i�3��`c%��Ԧ��l�.�T�.�L����ZH/�L��%�C]+�r}Fz���J�b�#�ͤ{yN3�~�^l�����t�d�=�i�=%��W��H��G��j�֗J�X�J:�|Az���/�9��Fj[I��fz��}%�ZI#���ɢj��?�(Q5��Fj�<%�\3;\��zU��(9O�oY5�Zu��z�}B���4S� ��Jz��VM�����|D�ٕ�-R룎��r[�N�J:%_���i�V}E��5�_���t�wB����$�QI�"���s<Z��-I0��^Ej�=�.
���"����k�Է�_�i�V}U�o5�Y��_H�Ђ��	vUңHm>�4m����`A%���z]���_-�ʠJ:5.�������\RӧHm�ǼaB���I����DjI��fJ��m$XTIO"���k4��kE���;��e��5S�3$��Yo"�}������>!��Jz�-!�����$XRI"��^G�i��׉�6���DWI��Lӿ&�5-�� ���&j&������2�m�B3U��m%XVI�!��F��L׿'�ֈJ����~C3e��7�� R;Dz��&m��	+�sHm��~��������ߐ�(��F���F��Q�tZ�Ez�f�~����;�Tp��s�5�{��$8�PH�!��Hw��f
��%XUI�!�1���5���E��T�_H��;��h���HpG�J:�I��l2��	�+�R[M��'4��'�,��J�
���>Yp�fJ���	��Rk���4���%�A�J��$=ʲ�ݲ�$8�Ao!�M���4S���*��Jz	�MTI�3���v�*�#���O�h��JpO�J:
E�I��}��_��b?!�����f���K����Aj?SI�p�f��-$*�T�;H����i��K�@�J�EgI��b·�	>U�!���tO�j����S�M��R���,�[3��ۢDմJ��u������	�^I砡�I��b��8	�Шo��ҽ=����`	�T�'Hm�j��^Mx�E����R��	�e�>�2	��YI����IO��Xu��z�}L��5��K����Jz��RM��#M?�c[JTͪ�/�Zo�H���WH�L�J:%_��dUW��$	�R�����@�h��W(��J���!]r��7��%	�V�H����;����E����+��7�'[�!�:Y�o4�	����`�iz��,��Jz ��#]�/5}��$�_��Oj�����W��4��N@����h�ſ-�E5}��v��u���`w%�>���tkizƇl-��J�|R�U�5}�5"�W2�S�;��4���\V3���^ҏ{S��K�������n�SM��S$X\�4Oj��>������H���L�4w������gJpU�����~��:��>%��dz'����\�K��	�V2���po��5���"o�d���ߒ~]�S~]��j�xR;Hz�������P%S:�-'��/5}�l/��J�sR�ݠ�-o)Y��N+7I����gIpS�i��
~C�Y��0��Y	�(2���J�����Q;J�Q%S8��V�n�����H��J�oRk�6�75��7%��M%9�H?oY����S��I�_���qM����$X]ɴMj�Kܬ�9o� ���J�lRk�.鹚��?��v�L�� =Ҳ�cّ�P��Im-�.����O�E���Lդ6A%Yp����͂D��J�iR��G��5=���c%6E�H��=]���(�)���֓��iM���$X_��Lj�U�whz�;,HTL�dj&�N��}M?z��u�d���闭�HV-��U��Im#�������C���Lɤ6Շd�]���.�L�d:&�.�~Kӛ~K���V21S��aEw��X	>�pZ&�ͤ{yNӟ>oo	�}%�0�MWMݣ�Q�(Q5��)��zxLz��O�T��zT2��9��}�S����S��Im+�>^���/�W��+�zIm�j�臚~�G����YɴKj�<%�\ӳ^.�S�*��)�@z�U]˪%��4��گI�o}�l�d�%�٪�G�o���>K̩d�%�>�H���_�k�:}*�ti�kүX�����_k<��҃���a_u�;*�bI��.�_���oI�y�L������/5��"/�d���oI�jU7��;|��4Kj�H񺦟}�!�dZ%��[yP��>h+	T2���@/��5}��"��dr��%�S5��i��������~���7}L�=�L����tk�ۇm#��J�QR�>�V��^+RoH%*�\&=C��!�ͧSR�G�	o�t��I	����Ԗ�n������,�d�$�a^G�i���D^V�$J�H}ޯIpM�)�����U�g��$8XɔIj�H�������*�.Im���u���=��FT2qR��Q���	n��6I�0�g|����HpX��i��V�n��B��v�`e%S$��R�n��o)U�dIk�H����gKpK멒�
��~λ��w}N��
�L���+�=�����*�Im�r�?jz�-H�3��)��ںCz��/�O$��m%�#�I���3Zv���FR[C��'4��v�`M%S!��WIܪ�o� Q1��i������?����K��L�4p��(˺��|A��L����tWOi���*��J�?R���,�]�+�nA�bR%S�ut��BM�|��t�d��4闼�cZ�e	�Vq
$������g~��l�d�#�)*�����w�B�bJ%��u��bM�|�t�d��,�1VtO+���3�i��6���YM����$��J�9R���,�[�C�/%��U2őZw�H/��їH�H�J&;���8+:��I��FS�m!���^��H������f�&�����?�(Q5��i��zzBz���>-O��d���<�	VuU��Rp^iz#��$��K�����R�I%���RM��cMo}ǴU�+��H��g�Wh��3R�L�J&5J�"=ɪ��S
�R��Hm;�^���o-���La�6�t�O4}�s�`n%���U���׾(�s�*��h�ғ��:���M�1R�Iz��4��{+%�YɴEj�I�<�鹟X�`~%S��2�J�w_%���J&/j\$�ۚ��T	.���Hm7�^�}��P	vW2U��Bҭ=����+��Hm���M~�H���LXԸLz��?]�˚MW����(����
������Q"�U%��-fVxR�:�B�+��Hm��N���LR�p�W���Hm?]T2%��R:9���ɉ��ts�>MQ�:�����8DG�CS���b���l8�J��~6�����*�e23���7J�V���$������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������L������U������������������������������������������������������������?              [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bbevilvggkuyd"
path="res://.godot/imported/arrow.png-9a52328c9c8f79a188b7fabb13b1f3fc.ctex"
metadata={
"vram_texture": false
}
               RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/creepagons.gd ��������   PackedScene    res://tile_map.tscn ^!*>���   PackedScene    res://game_engine.tscn �kH1ؑx   Script    res://logic/hex_piece_logic.gd ��������   PackedScene    res://tutorial.tscn *� ��?tG      local://PackedScene_gp2aq �         PackedScene          	         names "   %      Creepagons    script    Node2D 
   GameBoard 	   position    scale    layer_0/tile_data    ExitButton    offset_left    offset_top    offset_right    offset_bottom    text    Button    GameEngine 	   HexPiece    Node    CurrentPlayer    Label    MyPlayerId    TilesOccupied    AdjcencyLabel    Winner    visible    PassTurnButton    MovesLeftLabel    PointsLabel 	   Tutorial    _on_cell_clicked    cell_clicked     _on_game_board_spacebar_pressed    spacebar_pressed    _on_exit_button_pressed    pressed    _on_game_engine_game_over 
   game_over    _on_pass_turn_button_pressed    	   variants    .                      
     B  (B
   ��C?��C?    t      ��������   ��������   ��������                       ��������  ��������                              ��������  ��������                              ��������                                       ��������                                                                                                                                                                                 ��������                                                                                                                                                     	                                             	                                             	         
                                             	         
                                             	         
                                                      	         
                                             	         
        	         	         	         	         	         	         	         	 	        
         
         
         
         
         
         
 	                                                              	         
                                                                             �A     PA     dB     �B      Exit                        �B     ;C     B      Current player:       (B     *C     �B      Playing as     ��C    ��C      tiles occupied = 0      B    @D     :C     D      Adjacency rules:
            ��C    �D     �B      WINNER      �C    @D    ��C     D   
   Pass turn      B    @D      Moves left: 2       B     �C     |B      points:                node_count             nodes     �   ��������       ����                      ���                                             ����         	      
               	               ���   
                        ����                           ����         	      
                                    ����         	      
                                    ����         	      
                                    ����         	      
                                    ����               	      
                                     ����      !   	   "   
   #      $      %                     ����      &   	   "   
         '      (                     ����         	   )   
   *      +      ,               ���   -                 conn_count             conns     *                                                          !                        !                         #   "              
       !   $                    node_paths              editable_instances              version             RSRC           RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/game_engine.gd ��������      local://PackedScene_bf5qq          PackedScene          	         names "         GameEngine    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC        RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/hex_piece_logic.gd ��������      local://PackedScene_enwtc          PackedScene          	         names "         HexPieceLogic    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://vmpuq7ruf484"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/lobby.gd ��������      local://PackedScene_ghy0k          PackedScene          	         names "         Lobby    layout_mode    anchors_preset    offset_right    offset_bottom    Control    LobbyPanel    offset_left    offset_top    script    Panel    Address    text 	   LineEdit    AddressLabel    Label 	   StatusOk    StatusFail    JoinButton    Button    HostButton    OfflineButton    _on_join_button_pressed    pressed    _on_host_button_pressed    _on_offline_button_pressed    	   variants    $                      B     �A      B    �D     �C               �B     �B     NC     C   
   127.0.0.1      �B     (C   	   Address:      �B     ?C     )C     VC     �B     6C     C     MC     �B     �B      Join      0B     �B     �B      Host      8B     B     C     �B      Play Offline       node_count    	         nodes     �   ��������       ����                                        
      ����                                 	                       ����                  	      
                                ����                              	                          ����                                                  ����                                                  ����                                                        ����                                                        ����                         !      "      #             conn_count             conns                                                                                   node_paths              editable_instances              version             RSRC             extends Node
#
## The port we will listen to
#const PORT = 9080
## Our WebSocketServer instance
#var _server = WebSocketPeer.new()
#
#func _ready():
	## Connect base signals to get notified of new client connections,
	## disconnections, and disconnect requests.
	#_server.client_connected.connect(_connected)
	#_server.client_disconnected.connect(_disconnected)
	#_server.client_close_request.connect(_close_request)
	## This signal is emitted when not using the Multiplayer API every time a
	## full packet is received.
	## Alternatively, you could check get_peer(PEER_ID).get_available_packets()
	## in a loop for each connected peer.
	#_server.data_received.connect(_on_data)
	## Start listening on the given port.
	#var err = _server.listen(PORT)
	#if err != OK:
		#print("Unable to start server")
		#set_process(false)
#
#func _connected(id, proto):
	## This is called when a new peer connects, "id" will be the assigned peer id,
	## "proto" will be the selected WebSocket sub-protocol (which is optional)
	#print("Client %d connected with protocol: %s" % [id, proto])
#
#func _close_request(id, code, reason):
	## This is called when a client notifies that it wishes to close the connection,
	## providing a reason string and close code.
	#print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])
#
#func _disconnected(id, was_clean = false):
	## This is called when a client disconnects, "id" will be the one of the
	## disconnecting client, "was_clean" will tell you if the disconnection
	## was correctly notified by the remote peer before closing the socket.
	#print("Client %d disconnected, clean: %s" % [id, str(was_clean)])
#
#func _on_data(id):
	## Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
	## and not get_packet directly when not using the MultiplayerAPI.
	#var pkt = _server.get_peer(id).get_packet()
	#print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
	#_server.get_peer(id).put_packet(pkt)
#
#func _process(delta):
	## Call this in _process or _physics_process.
	## Data transfer, and signals emission will only happen when calling this function.
	#_server.poll()
      RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/simulate.gd ��������   PackedScene    res://game_engine.tscn �kH1ؑx   PackedScene    res://tile_map.tscn ^!*>���      local://PackedScene_ogmtg r         PackedScene          	         names "   
   	   Simulate    script    Node2D    GameEngine 
   GameBoard 	   position    scale    layer_0/tile_data    _on_game_board_cell_clicked    cell_clicked    	   variants                                   
     hB  B
   :?�Y?    .      ��������   ��������   ��������   ��������             ��������  ��������  ��������                     ��������  ��������  ��������                     ��������  ��������                              ��������  ��������                              ��������                                       ��������                                                                                     ��������                                                                              	          
                                                       	         
                                                      	         
                                                               	         
                                                               	         
                                                                        	         
                                                                        	         
                                                                                 	         
                                                                                 	         
                                            	         	         	         	         	         	         	         	         	 	        	 
        	         	         	         
         
         
         
         
         
         
         
 	        
 
        
         
         
                                                                         	         
                                                                                 	         
                                                                                 	         
                                                               	         
                       node_count             nodes        ��������       ����                      ���                      ���                                     conn_count             conns              	                       node_paths              editable_instances              version             RSRC GST2   �   �      ����               � �        6  RIFF.  WEBPVP8L!  /р+�� �$E�'��^
��w�p�H�"��N翅�C�� �$E�=�>N�=��t��$�I#=�
6.ِ���} �P=���  �p l�|@l�ȁh�ȁ(U�L@�� ;05���<�ZU�f̥kF�4CՌD�����Iu�ݨ~}Q5C5�����R�Dy�^T�H�f̥k�J�(�Ҍ�t�DQ}?*��&�R��t*կ/]}e�x
��&�j�C3E�j��<l�f�8<No
�q�Tӧk�u}[ʒQ>����NuZ_�����6P�����A�m��}�1j�6~�L���O\��׈�C�$ɉ��YHy���A{EG	�p���D��t��~�Y~����5|V�I����!I��]|��3��La�i�4�9���.֤������3A^?^�#��c�nb�aHT�g�+�t��3I?/�b�*3�s��ê�?���&/�'�h��(	z
x�L��5������FI�"���h	nd�6jB1�̾�`��Dan\{!�Q����{zOLxs{�;~!���|���:&�����B`�'�9�=�\�^Ah5۾g������ѯL~y��XjNtT�Ǆ3g;�g�Lv�Da�0&B��?!���FL��F##�ђ��险��n�7Z�6>�5���4���FN`�%mc$��`�4͕���4���FOP#&-c%�1��I�X	h4z/���`�@B�%����i�����	d,2���^�_�?���]Q���k3~'ʂ����4��&h�^�WBd����*�Y	���
>��/e�ϴ|(�D	M�����|(�DO�ީ�-펩�-����b6�<� �᫜'�3|� ��L�8�2-��{%q^�Ti���"����8M�&ћ*M�7Ej�3u�Dm괉��j�3u�Dm괉���2A "6���G�c�@�&
@�&��b�B�&�"7���	�	�i�b6��M��G�k0"5Q�8!q�HE����cb4(9z�Q�p���`�C�H��L���
�~��L��AF��M\�E� $|p�i6�A	� �b B10!��8B�'�����0Dk��㷯�m�HE��|"h�HM���7�VХՍ��y�n���m�|A����١ړa{*��p�� {�ϓU�e0�B�����+���aE>���F�8I���'�Я"�Я!9"1*��^Zb���=�H�H����0j��	i�$�Q��Ij�%�q��FLc!�����C�9���d5z�Ij3>��Xd�d ��}A���47o�I�A0���8�]ث ��8�m�e��緧 s�k�0E(s�k�E�?���N�0�ޙV��eH~s�k�C�w��?�"���U����2*�##���12Bɒ�h�u`����͹�94�&�����I�MB��d4�LB��d4�O^�e���T!�u������t/n�0�捠7qS'7u
"(n�"|p� |p$�C�z+	�D�\�aZ�6����p�M��p�MxKF��A�&�q�t�e��k����$$���H,"F��8F|&)���LV"70q��Dmp�1y���b2�a�ä&J����������ۺ����M�uG�ˏ�����G�=��=� ����p�g�\V���0:�^�(� ��""'�$�ȯ"�ȯ%�/�t��,S��FHH#'ɍ�pFOR)���d6Z�Il�7���	lL$��ԸHRc ���A0�#)��4��d4N'�h�$6N��XIh�$����XI>�%��t�Lc&錙�L�7���d3nR7ɒ�c):w�P�.H�:��9�>ӑ�82Á�>V�5�2|�T{���X�,���/��U_��+׀����="�Cܦ��m�]ŬrO�e�dM�L"�����*�������/�U�D���q�:���)��IE��ެdMt�E\&JI\&J2�2�V�	oɈ�4�Ǆ�F|�E�&��&1�|�e��k�A��d$�II#>��Hl&+���LZ�68�Dl�1���0�a2�����&J���   [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://ymhpqx8i3bgt"
path="res://.godot/imported/tiles.png-20e12ed313f9b52ca4483ea23302e684.ctex"
metadata={
"vram_texture": false
}
                RSRC                    PackedScene            ��������                                            2      resource_local_to_scene    resource_name    texture    margins    separation    texture_region_size    use_texture_padding    0:0/next_alternative_id    0:0/0 &   0:0/0/physics_layer_0/linear_velocity '   0:0/0/physics_layer_0/angular_velocity    0:0/0/script    1:0/next_alternative_id    1:0/0 &   1:0/0/physics_layer_0/linear_velocity '   1:0/0/physics_layer_0/angular_velocity    1:0/0/script    1:1/0 &   1:1/0/physics_layer_0/linear_velocity '   1:1/0/physics_layer_0/angular_velocity    1:1/0/script    2:0/0 &   2:0/0/physics_layer_0/linear_velocity '   2:0/0/physics_layer_0/angular_velocity    2:0/0/script    2:1/0 &   2:1/0/physics_layer_0/linear_velocity '   2:1/0/physics_layer_0/angular_velocity    2:1/0/script    1:2/0 &   1:2/0/physics_layer_0/linear_velocity '   1:2/0/physics_layer_0/angular_velocity    1:2/0/script    2:2/0 &   2:2/0/physics_layer_0/linear_velocity '   2:2/0/physics_layer_0/angular_velocity    2:2/0/script    script    tile_shape    tile_layout    tile_offset_axis 
   tile_size    uv_clipping     physics_layer_0/collision_layer    terrain_set_0/mode 
   sources/1    tile_proxies/source_level    tile_proxies/coords_level    tile_proxies/alternative_level 	   _bundled    
   Texture2D    res://tiles.png ���ZG�   Script #   res://logic/tile_map_controller.gd ��������   !   local://TileSetAtlasSource_regym ,         local://TileSet_aambc �         local://PackedScene_0gudr ?         TileSetAtlasSource !                   -   F   :                      	   
           
                                      
                                        
                                        
                                        
                                        
                            !          "   
           #          $      %         TileSet    &         (         )   -   F   :   +         ,          -             %         PackedScene    1      	         names "         TileMap 	   position 	   tile_set    format    layer_0/tile_data    script    	   variants       
     �C  �B                   �                                                                                                                                                                                                                                                                                                                                                           node_count             nodes        ��������        ����                                            conn_count              conns               node_paths              editable_instances              version       %      RSRC        RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    content_margin_left    content_margin_top    content_margin_right    content_margin_bottom 	   bg_color    draw_center    skew    border_width_left    border_width_top    border_width_right    border_width_bottom    border_color    border_blend    corner_radius_top_left    corner_radius_top_right    corner_radius_bottom_right    corner_radius_bottom_left    corner_detail    expand_margin_left    expand_margin_top    expand_margin_right    expand_margin_bottom    shadow_color    shadow_size    shadow_offset    anti_aliasing    anti_aliasing_size    script 	   _bundled       Script    res://logic/tutorial_panel.gd ��������
   Texture2D    res://arrow.png ��η�9"   PackedScene    res://tile_map.tscn ^!*>���      local://StyleBoxFlat_bk36y �         local://PackedScene_6njl1          StyleBoxFlat          �{�>�{�>�{�>  �?         PackedScene          	         names "   <   	   Tutorial    Node2D    TutorialPanel    visible    clip_children    offset_right    offset_bottom    scale    theme_override_styles/panel    script    Panel    Arrow    self_modulate 	   position 	   rotation    texture 	   Sprite2D    Arrow2    Arrow3    Arrow8    TileMap    layer_0/tile_data    Label    layout_mode    offset_left    offset_top    text    Label2    Label13    Label12    Label11    Label10    Label3    Label7    Label9    Label8    Arrow4    Arrow5    Arrow6    Arrow7    Arrow9    Arrow10    Arrow11    Arrow12    Arrow13    Arrow14    Arrow15    Arrow16    Label4    Label6    Label5    Label14    Label15    Label16    Label17    Label18    Label19    Button    _on_button_pressed    pressed    	   variants    ~                    �-D     RD
     �?��u?                         �?���=      �?
   P5D�*iB   ��?
   ���<~1 =         
   P�D�*iB   r�>��?��p=  �?
   ��D.�B   �ɿ
     !C ��C   �I@
   WU�<���<         
    ��C�*�B
   �T?�T?          ��������   ��������   ��������                     ��������  ��������  ��������                   ��������  ��������  ��������  ��������  ��������   ��������  ��������  ��������                        ��������  ��������                   ��������  ��������  ��������                              ��������  ��������  ��������  ��������   ��������  ��������  ��������  ��������  ��������          ��������  ��������  ��������  ����������        ��        ��        ��        ��      ��      ��      ��      ��      ��      ��      ��      ��      ��      ��      ��                     ��        ��        ��        ��      ��      ��      ��	      ��      ��      ��	      ��      ��      ��              ��      ��              ��                                                           	        	                      ��        ��        ��        ��        ��        ��        ��        ��      ��      ��      ��      ��      ��      ��      ��                                                  ��                                                        ��        ��        ��        ��        ��        ��        ��        ��      ��      ��      ��      ��      ��      ��      ��                                          ��                                                                              ��        ��        ��        ��        ��        ��        ��      ��      ��      ��      ��      ��      ��      ��                ��        ��                                                                                                             �A     �A    �
D     �B   N   1. Cells can be dead (0 health, beige) or alive
 (1 health, white or black)

      �A   ��B     �C   ���C   �   2. For every cell, the number of adjacent alive tiles 
 give the "health gain" which will be applied next round. 
owned neighbours -> health gain:
0 -> 0
1 -> 0
2 -> 0
3 -> 1
4 -> 1
5 -> 0
6 -> -1    ��'?    ��>  �?    ��C     HC    ��C     aC
   �m,?/N4?      +0     ��C   ?�FC    �D   ?�_C      +1    q�>���>      �?    ��C    ��C
   ��1?��1?      +1       �C     �C      -1      C   �EC     /C   �^C     �A    ��C    @D    0�C   |   3. You can click on a cell to add 1 health gain. You have 2 clicks on your turn. 
You have 0 clicks on your opponents turn!    ϼ<>��?�� <  �?    �D    @�B     #D    �$C
   ¡[?¡[?      white health gain      �?          �?     �A    �"D    �3B      black health gain 
   �GD���B
   WU�<~1 =
    ��C���C
   WU�<µ�<
     �C ��C
    ��C���C
   j| C!�D
   5>�Cq�D
   5��C!�D
   5>�Cq�D
   j| C�5D
   5>�C!�4D
   5��C�5D
   5>�C!�4D     C   ��!D     -C   �:(D    ��C   Pu!D    ��C   P�'D    ��C   �*D    ��C   �jD    ��C    �D    �D    �D     �C   P="D    �D   P}(D      +1
      �C     �@    �D     )C    HD      click on middle tile      �A     2D     �B     9D   
   pass turn     �D    @=D    @+D     ED      Toggle Tutorial       node_count    '         nodes     �  ��������       ����                
      ����                                        	                       ����                  	      
                          ����                  	      
                          ����                        
                          ����                                      ���                                            ����                                                        ����                                     !                    ����      "            #      $      %      &      '      (                    ����      "            )      *      +      ,      -                    ����      .            /      $      0      &      1      2                    ����      .            3      *      4      ,      5                     ����      .            6      7      8      9      -                 !   ����            :      ;      <      =      >                 "   ����      ?            @      A      B      C      D      E                 #   ����      F            @      G      H      I      D      J                 $   ����            K            L                       %   ����      M            N                       &   ����      O            N                       '   ����      P            N                       (   ����      Q                                   )   ����      R            N                       *   ����      S            N                       +   ����      T            N                       ,   ����      U                                   -   ����      V            N                       .   ����      W            N                       /   ����      X            N                       0   ����      .            Y      Z      [      \      -                 1   ����      .            ]      ^      _      `      -                 2   ����      .            6      7      8      9      -                 3   ����      .            a      b      c      d      5                 4   ����      "            e      f      g      h      -                 5   ����      "            i      j      k      l      '      m                 6   ����      .            n      j      @      l      1      2                 7   ����            o      p      q      r      s                 8   ����            t      u      v      w      x               9   9   ����      y      z      {      |      }             conn_count             conns        &      ;   :                    node_paths              editable_instances              version             RSRC        [remap]

path="res://.godot/exported/133200997/export-2c0b74ff05f65254759fd6e42c74af28-creepagons.scn"
         [remap]

path="res://.godot/exported/133200997/export-d9e4c8cfe69d689f3f1e0705b64e1057-game_engine.scn"
        [remap]

path="res://.godot/exported/133200997/export-ed741d667641bac3123dedd5ca607399-hex_piece_logic.scn"
    [remap]

path="res://.godot/exported/133200997/export-23186f883164cbeaffe487e6aecd5af8-lobby.scn"
              [remap]

path="res://.godot/exported/133200997/export-8a1bc4a5e065b660eda929a3d643d9f2-simulate.scn"
           [remap]

path="res://.godot/exported/133200997/export-22792ee0018d439a895e1f6e6e7db267-tile_map.scn"
           [remap]

path="res://.godot/exported/133200997/export-7d2e871219e9bd7bcea6e0a9676cd88c-tutorial.scn"
           list=Array[Dictionary]([{
"base": &"Node",
"class": &"GameEngine",
"icon": "",
"language": &"GDScript",
"path": "res://logic/game_engine.gd"
}, {
"base": &"Node",
"class": &"HexPieceLogic",
"icon": "",
"language": &"GDScript",
"path": "res://logic/hex_piece_logic.gd"
}])
<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              �ԡ�Iv   res://1.pngLc���-<   res://2.png���C�(   res://3.png^C�L,�(   res://4.png���)��C   res://5.png*��HH&i   res://6.png�9G��iVl   res://7.png��η�9"   res://arrow.png�%x��qF   res://creepagons.tscn�kH1ؑx   res://game_engine.tscn��u�6eW   res://hex_piece_logic.tscn{>���   res://icon.svgf���]��7   res://lobby.tscn�H���w   res://simulate.tscn���ZG�   res://tiles.png^!*>���   res://tile_map.tscn*� ��?tG   res://tutorial.tscn         ECFG      application/config/name      	   Bestagons      application/run/main_scene         res://lobby.tscn   application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg  "   display/window/size/viewport_width      �  #   display/window/size/viewport_height                 