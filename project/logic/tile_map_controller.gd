extends TileMap

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
