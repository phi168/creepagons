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
@onready var exit_button = $ExitButton
@onready var current_player_label = $CurrentPlayer
@onready var my_player_label = $MyPlayerId
@onready var tiles_occupied_label = $TilesOccupied
@onready var winner_label = $Winner
@onready var adjacney_label = $AdjcencyLabel
@onready var moves_left_label = $MovesLeftLabel
@onready var points_label = $PointsLabel


func _ready() -> void:
	is_online = len(multiplayer.get_peers()) > 0
	exit_button.pressed.connect(_on_exit_button_pressed)
	var width = tile_map.get_used_rect().size.x
	var height = tile_map.get_used_rect().size.y
	tile_map.init_text(height, width)
	game_engine.get_base_deltas()
	adjacney_label.text = "Adjacency rules: %s" % game_engine.adj_delta_rules
	tile_map.render_game_state(game_engine.grid)
	current_player_id = 1
	current_player_label.text = "White's turn"
	if not is_online:
		my_player_id = 1
		my_player_label.text = "playing as white."
	else:
		my_player_id = -1
		my_player_label.text = "playing as unknown"

func set_starting_player(player_id):
	if multiplayer.get_unique_id() == player_id or player_id == -1:
		my_player_id = 1
		my_player_label.text = "playing as white."
	else:
		my_player_id = 2
		my_player_label.text = "playing as black."
	
func _on_cell_clicked(pos_clicked: Vector2) -> void:
	if not visible:
		return
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
	if is_online:
		rpc_id(1, "send_move", pos_clicked)
	else:
		process_move(pos_clicked)

func _on_exit_button_pressed():
	print("exit_button_pressed")
	game_finished.emit()

func _on_game_engine_game_over(winner):
	winner_label.visible = true
	winner_label.text = "winner is player %s" % winner
	# block further moves
	current_player_id = -1

func _on_pass_turn_button_pressed():
	if is_online:
		rpc_id(1, "send_next_turn")
	else: 
		next_turn()

func _on_game_board_spacebar_pressed():
	pass # disabling this because space bar already retriggers the previous button anyway
	#rpc("next_turn")

# advance turn
@rpc
func next_turn():
	print(my_player_id)
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
	# if we are not online, we still, the the player changes here:
	if not is_online:
		my_player_id = current_player_id
		my_player_label.text = "playing as %s" % id_to_str[my_player_id]
	# print out
	print("It is now player %d's turn" % current_player_id)

@rpc
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

@rpc
func send_next_turn():
	#server side function
	pass

@rpc
func send_move(pos_clicked):
	#server side function
	pass
