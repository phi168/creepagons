GDPC                �	                                                                         T   res://.godot/exported/133200997/export-22792ee0018d439a895e1f6e6e7db267-tile_map.scn�      8      -=���տ��B�>왼�    T   res://.godot/exported/133200997/export-23186f883164cbeaffe487e6aecd5af8-lobby.scn    w      �      E���{=�>z:1 ^6�    X   res://.godot/exported/133200997/export-2c0b74ff05f65254759fd6e42c74af28-creepagons.scn  @;      �      B�/fP��{&���    T   res://.godot/exported/133200997/export-8a1bc4a5e065b660eda929a3d643d9f2-simulate.scn       �      \=_��mR�o��)���    X   res://.godot/exported/133200997/export-d9e4c8cfe69d689f3f1e0705b64e1057-game_engine.scn I      x      P��k�e����R���    \   res://.godot/exported/133200997/export-ed741d667641bac3123dedd5ca607399-hex_piece_logic.scn �f            ��j�9����Wz[���    ,   res://.godot/global_script_class_cache.cfg  У            �Mt�����wqc�R�/W    H   res://.godot/imported/hex_grid.png-3c8ae0c01c0cb53179044f008dbae01f.ctex�K      V      �_����ԉ��?��~    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex@i            ：Qt�E�cO���    H   res://.godot/imported/tiles.png-20e12ed313f9b52ca4483ea23302e684.ctex   ��      n      ҉���.���&��2�       res://.godot/uid_cache.bin  ��            �����P����M��       res://creepagons.tscn.remap 0�      g       ��3Ҥ(��X�J����       res://game_engine.tscn.remap��      h       �ߊ}*������/]"xp       res://hex_grid.png.import   �e      �       ������h�7`�6��        res://hex_piece_logic.tscn.remap�      l       .aB�-�+ΒptK��       res://icon.svg  �      �      k����X3Y���f       res://icon.svg.import   `v      �       �?���I��֞9       res://lobby.tscn.remap  ��      b       �ې�=3���!��       res://logic/creepagons.gd           :      �<�w�m��9�Ƶ*]z       res://logic/game_engine.gd  @      �
      i[d)z�.��{�p�7        res://logic/hex_piece_logic.gd              �=�-��VY��H�+       res://logic/lobby.gd0            A�����S�XOm��       res://logic/simulate.gd P,            O/G��Y�^�i�vQ    $   res://logic/tile_map_controller.gd  p2      �      Uɗ�ӝ�Y�����z       res://project.binary��      X      �|�E��_V���s-       res://simulate.tscn.remap   �      e       {��i��$X��C���       res://tile_map.tscn.remap   `�      e       ����/tw*��i���ߖ       res://tiles.png.import   �      �       �3�Wa�C%V�:Ud            extends Node2D

signal game_finished()

# Player state variables
var current_player_id: int
var player_ids: Array = [1, 2]
var my_player_id: int
var is_online: bool = false
var moves_remaining: int = 3

# Reference to the nodes
@onready var tile_map = $GameBoard
@onready var game_engine = $GameEngine
@onready var current_player_label = $CurrentPlayer
@onready var my_player_label = $MyPlayerId
@onready var tiles_occupied_label = $TilesOccupied
@onready var winner_label = $Winner


func _ready() -> void:
	is_online = len(multiplayer.get_peers()) > 0
	var width = tile_map.get_used_rect().size.x
	var height = tile_map.get_used_rect().size.y
	tile_map.init_text(height, width)
	game_engine.get_base_deltas()
	tile_map.render_game_state(game_engine.grid)
	current_player_id = 1
	current_player_label.text = "White's turn"
	if multiplayer.is_server():
		my_player_id = 1
		my_player_label.text = "playing as white"
	else:
		my_player_id = 2
		my_player_label.text = "playing as black"
		
# advance turn
func next_turn():
	# we need to change the current player:
	# find the current index
	var current_index = player_ids.find(current_player_id)
	current_player_id = player_ids[(current_index + 1) % 2]
	var id_to_str = {1: 'white', 2: 'black'}
	current_player_label.text = "%s's turn" % id_to_str[current_player_id]
	moves_remaining = 3
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
	# broadcast click to all players
	rpc("process_move", pos_clicked)

@rpc("any_peer", "call_local")
func process_move(pos_clicked: Vector2) -> void:
	# Send the move to the game engine
	var current_index = player_ids.find(current_player_id) + 1
	moves_remaining -= 1
	if game_engine.place_piece(pos_clicked.x, pos_clicked.y, current_index):
		# Update the game state after the move
		tile_map.render_game_state(game_engine.grid)
		# Switch turns
		if moves_remaining == 0:
			# apply changes of cell ownership / hp
			game_engine.update_game_state()
			# calculate the next prospective deltas
			game_engine.get_base_deltas()
			# render the new state
			tile_map.render_game_state(game_engine.grid)
			tiles_occupied_label.text = "tiles occupied = %s/%s" % [game_engine.num_occupied_tiles, game_engine.max_occupied_tiles]
			next_turn()
	else:
		print("Move was not valid according to the game rules.")

func _on_exit_button_pressed():
	game_finished.emit()

func _on_game_engine_game_over(winner):
	winner_label.visible = true
	winner_label.text = "winner is player %s (%s/%s w/b)" % [winner, game_engine.num_tiles_p1, game_engine.num_tiles_p2]
	# block further moves
	current_player_id = -1
      extends Node

class_name GameEngine

signal game_over(winner: int)

var height: int
var width: int
var grid: Array = []
var adj_delta_rules = {
	0: -2, 
	1: -1, 
	2: 0, 
	3: 1, 
	4: 1, 
	5: 0, 
	6: -1,
}
var num_occupied_tiles: int
var max_occupied_tiles: int = 60
var num_tiles_p1 = 0
var num_tiles_p2 = 0
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
	num_tiles_p2 = 0
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
	
            # HexGridLogic.gd
extends Node

class_name HexPieceLogic

var _owner: int = 0  # 0 means unoccupied, 1 for player 1, 2 for player 2
var health: int = 0
var max_health: int = 2
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

# Default game server port. Can be any number between 1024 and 49151.
# Not present on the list of registered or common ports as of December 2022:
# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
const DEFAULT_PORT = 8910


# Server instance
var peer: ENetMultiplayerPeer

@onready var address = $Address
@onready var host_button = $HostButton
@onready var join_button = $JoinButton
@onready var status_ok = $StatusOk
@onready var status_fail = $StatusFail

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
		get_node(^"/root/Creepagons").free()
		show()

	multiplayer.set_multiplayer_peer(null) # Remove peer.
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
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(DEFAULT_PORT, 1) # Maximum of 1 peer, since it's a 2-player game.
	if err != OK:
		# Is another server running?
		_set_status("Can't host, address in use.",false)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)

	multiplayer.set_multiplayer_peer(peer)
	host_button.set_disabled(true)
	join_button.set_disabled(true)
	_set_status("Waiting for player...", true)


func _on_join_button_pressed():
	var ip = address.get_text()
	if not ip.is_valid_ip_address():
		_set_status("IP address is invalid.", false)
		return
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, DEFAULT_PORT)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

	_set_status("Connecting...", true)


func _on_offline_button_pressed():
	_player_connected(2)
              extends Node2D

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

func update_tile(pos_clicked: Vector2, hex: HexPieceLogic) -> void:
	var health = hex.health - 1
	if health > 2: 
		health = 2 # we can't render anything greater than 3 right now
		
	var tile = Vector2i(hex._owner, health + 1)
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
				text_labels[x][y].text = hex.rendered_text
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
    RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/creepagons.gd ��������   PackedScene    res://tile_map.tscn ^!*>���   PackedScene    res://game_engine.tscn �kH1ؑx   Script    res://logic/hex_piece_logic.gd ��������      local://PackedScene_llnby �         PackedScene          	         names "         Creepagons    script    Node2D 
   GameBoard 	   position    scale    layer_0/tile_data    ExitButton    offset_left    offset_top    offset_right    offset_bottom    text    Button    GameEngine 	   HexPiece    Node    CurrentPlayer    Label    MyPlayerId    TilesOccupied    Winner    visible    _on_cell_clicked    cell_clicked    _on_exit_button_pressed    pressed    _on_game_engine_game_over 
   game_over    	   variants                          
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
                                                                             �A     PA     dB     �B      Exit                        �B     ;C     B      Current player:       (B     *C     �B      Playing as     ��C    ��C      tiles occupied = 0             �C      WINNER       node_count    	         nodes     }   ��������       ����                      ���                                             ����         	      
               	               ���   
                        ����                           ����         	      
                                    ����         	      
                                    ����         	      
                                    ����               	      
                            conn_count             conns                                                                                                             node_paths              editable_instances              version             RSRC    RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/game_engine.gd ��������      local://PackedScene_bf5qq          PackedScene          	         names "         GameEngine    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC        GST2            ����                          RIFF  WEBPVP8L	  /��?�(h�Fj���?1�Г��LF��(k�-m#d-��mUO�N��/�\{pwh�r�y����C]Ƕ�$�L��PC�A�Ϭnb�v�u���Pb sB�m����訍$I�T����|o@rɑ�����'�ʶ����������7��P�~G�#XR�N����,ٗ��Z���dۊ$�{���Q�z���^@�(�2�y�7J<��4�a�cQ��WЍlۑ�\�:Tس2���,�HEiI)�IMGlE�-����>Yn�ڶ�H�%.�N��ׅ�7Da5,;V�{�P
Z�U�`�ѷR$G�$)��L�����e�N$W�8��#����؏�񸹻8�Tef����l�f��ݜ�ѶMu�g�;�s�\�a�TtN���K�0KB��|g����]m{��]1�M�t���X�CzO�h
�Z 8�l۶g�	��¬К,Ƀඍ$INa����c_ Ƕm�����U�s�2T�l�K+�&��b����T��$GRVUw��^��K��ض��9��5:��S�rE�P����e�
!1��:lv��!��:ȷ����m�ȞbL�i�_���v��-�eOi�T�@����ϯT���K)�CR$ɑ�QE6���؄LVC���m�lO��p�9t�� Aʯ�� )��H
� I��hQ�8���}�~c>�lܶ���ݭ."�>���1Ƙ-�c���ǿ��ɦ���H8����#���/a��S���cT���gT�����ﮄW�<ǡri��P� �ٟRRIJ%)���+_��,$��[�t���NA�RJJ�릈N(��M+#�`�uSBW��IA�ZB;ř��ׁB:P�!yү\WM�s��F�q��^L(TTG�fڟ�?e�|$�7{���&����=-u��� �k=׮�+E����5����gҁ*�ͭ��e��J���H�"���I:��4�c��e����A50S��і"�J8������'݈zG�;��dc�S�*�`�z�����������sS�禮D��W���Ҍ�Wd�";�I2�>���m��u	�KD[�Qx��c�`|����O$�1���_ R����:�M�B���N�������ΉCx���\ĥ��\�rR���G��QxTwcw�R���nh�\eQ���4<��Z���K{7�t�="��q�(����팥Q�ݰ����rr��d�+�����swx����B�2)��MJ�H�-�s.�ws҉�	\��NGP7���ǅc��MI)�&p��(u���NV_�id��Q�r�v�b��1�nݍJt7���c8R�q��q�Q���_�>����s�Z/]������ᘿ�Gǭ}�ԯ��
$t\��92�W2E��b��@5�ߧ!�[�!Jw���Cɼ[���uE�z���L�^
t�/�{�S�� ��O�����7�]�� ��Lb�k���=��4y�q��ʔ�b<{�7*��Yh��z��B��Ɵ*�^������,�Ŭ�F(�|�֛�?#'�����X����3�4��qz2d!ӑ%f��S*������ܹ2V	�E���>�QƜ�.f줯��281��xA�ep:�[����M?#wL�V�������������S�m��Lݝ۟/�N�����IFN"���̿%
���H�&��&P  `��������� �< �O_  ���ZG0��j����@v ��=wJPN�� ����`<
0�`���1��bO�Lk<[c��̞�1�8����u�(j�RcdT�a���v��W���X#� 	� y���@�� 9���po���Ea�����>o��u%���m|���y��-?�;H� 5 �N�%0ŷ�T� Ps���(v��N�b���	����O�;9�����!	@] �v�2��W˷�&���}�����cm ~�=%�L����~���>T���!��OTЦ�k��]E�}�%2�@��I�U �\:�r��=g�M6R��<�K����٩�m���B�H�zk�o���c{�v�M3RJ���ԟ����L�qU�V	 ����7�i�C|N�|~�������  `�e�U�=�����s����! �w��D�%%�z .�`��e�T�[�  �wc����e$���m�g~3fܚmcT����bvw1%\�\�\���5�L�����3f<l�m�m �@v7`�w[�.fw�������I>tP���n���mKۖ�-l�p�5P�-}�hϹ�sMK��|��c�DEF"7<a��m[ٶ$ 8d�dNf�H�������>���w����fN�]|��c';dt�I���f�h�(%��C��ԁ&��V�ƕ��g��_}������ݟ?暅kf>t�C7>v�SFgF��k<��n�P�ΡΡơ+ĲX��Lh��~���!v7�ۏ~�_~���'��W[�>�|���n2�dt��HP�R� ��mZ8��*�R�`9,gdqh�T�u���O߽��g�������>�,���nIE�`�,Ū```k��U,������)�:t�[̹�q���S����O<�o2z�ѳ�n��d�Fi>�-�J
0돇��XC����ۯ��qG4Y����珞��4�?��X]W���\�V��`c�F� �H)�3�T8���O,o~e��A
HA����+��9��|v���5m��Z�Q�y�f$Y�uD�R�������=.~e�+�A
�r�ǽ�ơ���@0��n����sdm[)�r�f�!�rP��6>9�H���^ \��x���_9���"IZw%v:�]�ch|�������?7��C�5�Õ�����o>���s U�ߍ��E� ��Ɋ9��G��1�[~�c������G�w���[�8GjQ��Y9L�K�S��@=����� Ny��8z�G99��AN�2���o��7N&����K�җ�@_0ޛ+��ތ=T��p#	���x�פ�cP�ƪ��6rrvr�^B����V�㷙PF�Ea��	���z���_����{C?G��
�*ܐM�Fڈ�|r�*�^B��6�{um���8���}ܵ���qWw��!�%s�ݟ��_��A������'�����O{�!���yɳ�UKd��HI���36��1tm��	��>��}L��1���!+B���_%{���-���߼�S���pח 5d+���f��  ���ӏ[wR�1�t'��Q��sw��%dM!�BV�,7R�=��R��Qɽ{�?����ֳ�ʹ���
����%Z%�Jʕd��J"Y�}?@-�c�-�m�.c�j�ti��F�	Y#dM!�	�nn�}v��~-�{�k�aOݖ�gS���_ӽ5��d����\GHG�.��'��&G��	�(W���jr0�?
�6u�٩�n�n����|��\l�*�����R�ס#<�$�ɯ�����4�[jK�[j��fG�m­�:��q��9���)��c�&����~kU��^�uD�YGX"������ؤ_>�n u��k�R���o��I��ȷ�Ȕ���^�._��9��7���nv��)�����o������
}�㫷��U��W&���r!U$����H ��g$�nv���������Ǆo��7 &���Pe��:{4����%������~���fg  E�Ʃ�����_�o�6~V>0����\$��    ��vj}0`���(����`��Z�_���|�X�{8�3�Yb��  ��A���wum��յ!�G ��j��R1|��������7 ��� X43(^#�>(^�H����M_��;�ƩM'��M���}� ��M�m�kR!�kRa�t���p�c�k�\��Aߝ�;]-�i�"�s�������s����n��|�����j�{�n�\��N������M_�uꍻ���|K�0� <�O W�0�9��y,�vҧy)�߾�<������k�|@꼨��s �y7 "�C	K:��B��~μ�>��w�|S�Hk�����ط�� ^���!�e���૞�cpY�ﲚ.�)��2D�]�mڭ�S75�Q"���mYM�j�M� �J��;2bjs��PE0�ߏۓg�nZ<��v������6��e55�&@�8�o��8�H�~԰ ��M�YĲE,[���Ο�@��H���� @v��E,�u�7 �	���'��~�G9� �_���  �7�bn���mn�5B��KF6N��|��o��&��t��u��۴�[�V�� �db�"��6���p��[jc��ik2mM[�i+L[1�n�V��ʴ���.(���������V���X�Y��ĺӴu�@�i��ź?�nb�W��=I&Ů_�)����t)v=��JĺC�;L[1�n�uĺ�, *�t��|?%v v lz��i�Ӳ�Y]�U=��gV�j����o��> l x ź����Y�ŹoO˞�&OK�6�ua6����g �S�W׆��>R� l���d�݋�ʢ�XԶIq4�kTר^U�������^� X-��Q���7��S�J��e�J�<�y[�:�7���^w��{�:`�t���}���wZ>jy��< F}uC��v;�ݎ-���^�� ~}���^���,�s-<����  (3; @~i�#����vX�c��^1�����ٰ*<���D� �Y�y[5jpN�y�N'�W�{��58�`�V�s���+ �X^:eQ�����L�r��|�E��D�&���<�0�����w�)ȧ �9�ɀ�w�%�y��W9Ґ�*�k�εJ���{�����[�s
�]�[�#MpbIݫtnǣ'���Ő�!͐�l��U:��#'O�v>�Nrv�۽}4�gC���D�� �F�_��L~���]$�ډli݀	�g�lN|�ĕ!A#�$v@��1�G$�"��d�$"�d��u�-��H����� � @j�b  �H*��S;1���0����LS�$��|  �f�u3��y}��A�Mn6����� �����o|�nr�}>̬����)�I�L�(���ir�&�GMnhrCg��Mn��v��AS�"	 @)� ���k�^������ܐf��O3���ӌ����糢�E?�� @)i��D��U�O�Y����E?7E?U��E?A-�9�p>����`�� �~|����)Ƣ���׸A��_r^�r^F �-�8O�弼�)�X��)N��M��E΋伬�P��`�\���br^�N�p��d�h�M{��I>�z��,'�E,�伤dE�O4}��7��6�b,��yq�!!�&�˒X�,#�2�,��!w�,dY�e˒X�� � �烯; �Ȳ�,KZ��R���*�5� Ĳ�e!˒r7����@  �@J�v�+��*�D.|@ Ȳ0w�L���c0����ݹ�k3��i�%����ߺ�z��>�}r��ݜF�����[5�����'w+C�^�����y��>I���z�ܭ�[��|��Ϻ����l��I�#����w?\-���j������I��s����W`��w�� X>��5m{��=D��U� �x �����%�׼����w�&Z�'���3woch���߯y	=   �VܽM/@:` � .�X�x �-��Կ\}e���^���o�<��܀	�X:��W�3����   �ܜz[G���8�ǻ9��pV����Em��Ҟ�������g5���|~������ǳ��n��_N�8��W�a���0�vS��G  � 8 � �uݭ�X5� M`E6E^�\�	X�/-R�H�����#�G&:\}��h,��0 [��h ���Gw	 `i�2�(��5HK#�[����ֲ-�v�ˮxٓ��h�]�m�vۣ�v�ˎxْN[ҲA֨y.՚�Gqr��CE��w P��tew;�@�A�I�E�N�O� \�)�S�o5WoY�e���7W'W/��O@| >G��7�����aX�c��:Jfi�]+�s�Ԙ��T[y]H�9oD�ף�Q�5/B��Qg�}C���i������m�N:�u�u���5��Pi��t �[�ԟgWW7W7`��g#/�[��e�P:%�Kf.���B�#V+UO6o��f-H-�m
� k��,U+EՎ2v��3�R�T��;����tH�F�I 1&6	E�"E��4@�!���\��:e�����������nI���f�m#�9�*�A��Ϭ�c�a3�� �2��P�Tɴ�i%ӕ�+�l�l��dx3��E�"�1#����RQ)�v���N;��,��d�!��  �N�H��(�,q��I?��w�}�������\Y�J���rvmx�m��	�r��Ō뤯Y�2�l.1&ӏ�e ��ɒɒ)�&�f�͌hV2O�7}��Ƀ�SЃ��-e�´��N;�&�t2�M��CH�D�\:�gm�?���$#wj�v�TE�j�U_���W�Q׫R��[���y��+�N���������.�(�̣ܘƈ��<)oj����`j
*��貔*���c'�y�� �УA�\�TUf�?KQ��'�ܒR%t-��1��Ũ��2#�J�$���f��)� ���R�L�N� ����^��            [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cdc2jf4u46pd8"
path="res://.godot/imported/hex_grid.png-3c8ae0c01c0cb53179044f008dbae01f.ctex"
metadata={
"vram_texture": false
}
            RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/hex_piece_logic.gd ��������      local://PackedScene_enwtc          PackedScene          	         names "         HexPieceLogic    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
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
 RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/lobby.gd ��������      local://PackedScene_nfj01          PackedScene          	         names "         Lobby    layout_mode    anchors_preset    offset_right    offset_bottom    Control    LobbyPanel    offset_left    offset_top    script    Panel    Address    text 	   LineEdit    AddressLabel    Label 	   StatusOk    StatusFail    JoinButton    Button    HostButton    OfflineButton    _on_join_button_pressed    pressed    _on_host_button_pressed    _on_offline_button_pressed    	   variants    #                      B     �A      B    ��C     bC               �B     �B     NC     C   
   127.0.0.1      �B     (C   	   Address:      �B     �B     C     �B     �B     C     �B     �B     �B     C      Join      0B     �B     �B      Host      �A     B     �B      Offline       node_count    	         nodes     �   ��������       ����                                        
      ����                                 	                       ����                  	      
                                ����                              	                          ����                                                  ����                                                  ����                                                        ����                                                        ����                               !      "             conn_count             conns                                                                                   node_paths              editable_instances              version             RSRC          RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://logic/simulate.gd ��������   PackedScene    res://game_engine.tscn �kH1ؑx   PackedScene    res://tile_map.tscn ^!*>���      local://PackedScene_ogmtg r         PackedScene          	         names "   
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
     �C  �B                   �                                                                                                                                                                                                                                                                                                                                                           node_count             nodes        ��������        ����                                            conn_count              conns               node_paths              editable_instances              version       %      RSRC        [remap]

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
           	   �%x��qF   res://creepagons.tscn�kH1ؑx   res://game_engine.tscn��-4,=E   res://hex_grid.png��u�6eW   res://hex_piece_logic.tscn{>���   res://icon.svgf���]��7   res://lobby.tscn�H���w   res://simulate.tscn���ZG�   res://tiles.png^!*>���   res://tile_map.tscn      ECFG      application/config/name      	   Bestagons      application/run/main_scene         res://lobby.tscn   application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg  "   display/window/size/viewport_width      �  #   display/window/size/viewport_height      �          