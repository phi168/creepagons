extends Node

const max_num_moves := 2

var player_ids: Array = [1, 2]
var moves_remaining: int = max_num_moves

var server: Node 
var io: WebSocketServer

func _ready():
	server = get_parent()
	io = server.peer_internal


func receive_msg(peer_id, message: String):
	print("message received from bot %s" % peer_id)
	io.send(peer_id, 'ACK')
	var parts = message.split(":")  # Split the message at the colon
	if parts[0] == "MOVE":
		if len(parts) == 2:
			var pos = parts[1].split(",")
			pos = Vector2i(int(pos[0]), int(pos[1]))
			send_move(peer_id, pos)
			print("Move received. Position:", pos)
		else:
			print("Invalid MOVE command format.")
	elif parts[0] == "NEXT_TURN":
		send_next_turn(peer_id) 
		print("Next turn command received.")
	elif parts[0] == "GET_STATE":
		send_state(peer_id)
		print("Next turn command received.")
	else:
		print("Unknown command:", parts[0])

func send_state(peer_id):
	var session = server.sessions[peer_id]
	var state = get_stringified_game_state(session)
	io.send(session.player1_peer_id, state)

func start(session):
	var state = get_stringified_game_state(session)
	io.send(session.player1_peer_id, "PLAYERID:1")
	io.send(session.player2_peer_id, "PLAYERID:2")
	io.send(session.player1_peer_id, state)
	io.send(session.player2_peer_id, state)


func send_move(peer_id, pos_clicked):
	var session = server.sessions[peer_id]
	# check if move is allowed 
	var sending_player_id: int
	if session.player1_peer_id == peer_id:
		sending_player_id = 1
	elif session.player2_peer_id == peer_id:
		sending_player_id = 2
	else:
		print("peer id not found in session")
		return

	if session.game_instance.current_player_id != sending_player_id:
		print("not sending peer's turn")
		return

	session.game_instance.place_piece(pos_clicked.x, pos_clicked.y)
	if session.game_instance.moves_remaining == 0:
		session.game_instance.next_turn()

	var state = get_stringified_game_state(session)
	if session.game_instance.is_game_over:
		# if game is over, send winner instead
		state = "WINNER:%s" % session.game_instance.winner

	io.send(session.player1_peer_id, state)
	io.send(session.player2_peer_id, state)


func send_next_turn(session):
	session.game_instance.next_turn()
	var state = get_stringified_game_state(session)
	io.send(session.player1_peer_id, state)
	io.send(session.player2_peer_id, state)

func get_stringified_game_state(session):
	var game_state = session.get_game_state()
	var state = []
	for key in game_state:
		var val = JSON.stringify(game_state[key])
		state.append("%s:%s" % [key, val])
	return ';'.join(state)