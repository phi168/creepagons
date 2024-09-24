extends Node

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
	var peer_ids = server.look_up_sessions(source_id)
	rpc_id(peer_ids[0], "process_move", pos_clicked)
	rpc_id(peer_ids[1], "process_move", pos_clicked)


@rpc("any_peer")
func send_next_turn():
	var source_id = multiplayer.get_remote_sender_id()
	var peer_ids = server.look_up_sessions(source_id)
	rpc_id(peer_ids[0], "next_turn")
	rpc_id(peer_ids[1], "next_turn")
