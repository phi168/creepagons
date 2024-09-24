extends Node

# Session object handles the lifecycle of a game between two players

class_name Session

var session_id: String
var player1_peer_id: int
var player2_peer_id: int
var game_scene: Node

# Signal to indicate that the session should be ended
signal session_ended(session_id)

# Initialize the session with player peer IDs and the game scene
func _init(_session_id: String, _player1_peer_id: int, _player2_peer_id: int):
	session_id = _session_id
	player1_peer_id = _player1_peer_id
	player2_peer_id = _player2_peer_id
	game_scene = load("res://path_to_game_scene.tscn").instantiate()
	add_child(game_scene)

# Broadcast input to the other player
func broadcast_input(from_peer_id: int, input_data):
	var other_peer_id = get_other_peer_id(from_peer_id)
	if other_peer_id != -1:
		rpc_id(other_peer_id, "update_game_state", input_data)

# Get the peer ID of the other player in the session
func get_other_peer_id(peer_id: int) -> int:
	return player1_peer_id if peer_id == player2_peer_id else player2_peer_id

# Handle player disconnection
func player_disconnected(peer_id: int):
	print("Player ", peer_id, " disconnected")
	
	# End the session when a player disconnects
	end_session()

# End the session and notify both players (or handle disconnect)
func end_session():
	rpc_id(player1_peer_id, "on_game_end")
	rpc_id(player2_peer_id, "on_game_end")
	
	# Queue free the game scene and emit a signal to cleanup
	if game_scene:
		game_scene.queue_free()

	emit_signal("session_ended", session_id)

# Called to clean up the session resources
func cleanup():
	if game_scene:
		game_scene.queue_free()

