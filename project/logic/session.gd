extends Node

# Session object handles the lifecycle of a game between two players

class_name Session

var session_id: String
var player1_peer_id: int
var player2_peer_id: int # might be the bot id
var is_against_bot: bool

var game_instance: Node = null

# Signal to indicate that the session should be ended
signal session_ended(session_id)

# Initialize the session with player peer IDs and the game scene
func _init(_session_id: String, _player1_peer_id: int, _player2_peer_id: int):
	session_id = _session_id
	player1_peer_id = _player1_peer_id
	player2_peer_id = _player2_peer_id
	game_instance = GameEngine.new()
	add_child(game_instance, true)
	# need to call this manually because the session object isn' in the scene tree
	game_instance._ready()
	print("added game engine", game_instance)

# Get the peer ID of the other player in the session
func get_other_peer_id(peer_id: int) -> int:
	return player1_peer_id if peer_id == player2_peer_id else player2_peer_id

# End the session and notify both players (or handle disconnect)
func end_session():
	if game_instance != null:
		game_instance.queue_free()  
		game_instance = null

func get_game_state() -> Dictionary:
	var properties = ['_owner', 'health', 'health_delta', 'is_in_game']
	var game_state = {}
	for property in properties:
		game_state[property] = get_game_state_by_property(property)
	game_state['current_player_id'] = game_instance.current_player_id
	return game_state
	
func get_game_state_by_property(property):
	var grid = []
	for x in range(game_instance.width):
		var col = []
		for y in range(game_instance.height):
			var hex = game_instance.grid[x][y]
			col.append(hex.get(property))
		grid.append(col)
	return grid
