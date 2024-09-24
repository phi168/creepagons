extends Node

const max_num_moves := 2

var player_ids: Array = [1, 2]
var moves_remaining: int = max_num_moves

@onready var server = get_parent()


@rpc
func next_turn():
	#client side function
	pass

@rpc
func process_move(pos_clicked: Vector2) -> void:
	# client side funciton 
	pass

@rpc("any_peer")
func send_move(pos_clicked):
	var source_id = multiplayer.get_remote_sender_id()
	var session = server.sessions[source_id]
	session.game_instance.place_piece(pos_clicked.x, pos_clicked.y)
	rpc_id(session.player1_peer_id, "process_move", pos_clicked)
	rpc_id(session.player2_peer_id, "process_move", pos_clicked)


@rpc("any_peer")
func send_next_turn():
	var source_id = multiplayer.get_remote_sender_id()
	var session = server.sessions[source_id]
	session.game_instance.next_turn()
	rpc_id(session.player1_peer_id, "next_turn")
	rpc_id(session.player2_peer_id, "next_turn")
