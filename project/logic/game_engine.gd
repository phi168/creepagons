extends Node

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
const max_num_moves := 2
var moves_remaining: int = max_num_moves
var num_tiles_p1 = 0.0
var num_tiles_p2 = handicap
var is_game_over = false
var current_player_id: int = 1
var player_ids: Array = [1, 2]
var winner

@onready var tilemap =  preload("res://tile_map.tscn").instantiate()

func _ready():
	width = tilemap.get_used_rect().size.x
	height = tilemap.get_used_rect().size.y
	# Initialize a hex grid with side length 10
	# filling matrix column by column
	grid = []
	for _i in range(width): #horizontal
		var col = []
		for _j in range(height): #vertical
			var hex = HexPieceLogic.new()
			var is_in_game = tilemap.is_in_game(Vector2i(_i, _j))
			hex.is_in_game = is_in_game
			col.append(hex)
		grid.append(col)

	get_base_deltas()

func place_piece(x: int, y: int) -> bool:
	moves_remaining -= 1
	var hex = grid[x][y]
	hex.add_health_delta(1, current_player_id)
	return true
	
func get_base_deltas():
	# Iterate over each hex in the grid
	for x in range(width):
		for y in range(height):
			var hex = grid[x][y]
			if not hex.is_in_game:
				continue
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
			var hex = grid[x][y]
			if not hex.is_in_game:
				continue
			hex.apply_health_delta()
			if hex._owner != 0:
				num_occupied_tiles += 1
			if hex._owner == 1:
				num_tiles_p1 += 1
			elif hex._owner == 2:
				num_tiles_p2 += 1
	
	if num_occupied_tiles >= max_occupied_tiles:
		var num_tiles = [num_tiles_p1, num_tiles_p2]
		winner = num_tiles.find(num_tiles.max()) + 1
		is_game_over = true
		current_player_id = -1
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
			var adj_hex = grid[nx][ny]
			if adj_hex._owner != 0:
				adj_occupied[adj_hex._owner] += 1
	return adj_occupied


func next_turn():
	# apply changes of cell ownership / hp
	update_game_state()
	# calculate the next prospective deltas
	get_base_deltas()
	# we need to change the current player:
	# find the current index
	var current_index = player_ids.find(current_player_id)
	current_player_id = player_ids[(current_index + 1) % 2]
	moves_remaining = max_num_moves

func is_valid_move(pos_clicked):
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
	
