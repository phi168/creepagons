extends Node

class_name GameEngine

signal game_over(winner: int)

var height: int
var width: int
var grid: Array = []
var adj_delta_rules = {
	0: -1, 
	1: 0, 
	2: 0, 
	3: 1, 
	4: 1, 
	5: 0, 
	6: -1,
}
var num_occupied_tiles: int
var max_occupied_tiles: int = 60
var handicap = 2.1
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
	
