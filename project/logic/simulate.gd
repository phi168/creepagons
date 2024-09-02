extends Node2D

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
				
