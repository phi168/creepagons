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
func process_move(_pos_clicked: Vector2) -> void:
	# client side funciton 
	pass

@rpc("any_peer")
func send_move(pos_clicked):
	var source_id = multiplayer.get_remote_sender_id()
	var session = server.sessions[source_id]
	session.game_instance.place_piece(pos_clicked.x, pos_clicked.y)
	rpc_id(session.player1_peer_id, "process_move", pos_clicked)
	if not session.is_against_bot:
		rpc_id(session.player2_peer_id, "process_move", pos_clicked)


@rpc("any_peer")
func send_next_turn():
	var source_id = multiplayer.get_remote_sender_id()
	var session = server.sessions[source_id]
	session.game_instance.next_turn()
	rpc_id(session.player1_peer_id, "next_turn")
	if not session.is_against_bot:
		rpc_id(session.player2_peer_id, "next_turn")

	# need to check if playing against bot. If so, calculate the next moves and pass turn back to player
	if session.is_against_bot:
		perform_bot_moves(session)

func perform_bot_moves(session):
	# move 1
	var pos_clicked = request_move_from_bot(session)
	session.game_instance.place_piece(pos_clicked.x, pos_clicked.y)
	rpc_id(session.player1_peer_id, "process_move", pos_clicked)
	# move 2
	pos_clicked = request_move_from_bot(session)
	session.game_instance.place_piece(pos_clicked.x, pos_clicked.y)
	rpc_id(session.player1_peer_id, "process_move", pos_clicked)
	# pass turn
	session.game_instance.next_turn()
	rpc_id(session.player1_peer_id, "next_turn")

func request_move_from_bot(session):
	var game_state = session.get_game_state()
	var os_args = ["ai/cli.py"]
	for key in game_state:
		var val = JSON.stringify(game_state[key])
		os_args.append("--%s=%s" % [key, val])

	var stdout = []
	var exit_code = OS.execute("python", os_args, stdout)
	var pattern = RegEx.new()
	pattern.compile(r"\[\s*(\d+)\s+(\d+)\]")
	print(os_args)
	print(stdout)
	# Search the input string for matches
	var match = pattern.search(stdout[0])
	var x = int(match.get_string(1))  # First number
	var y = int(match.get_string(2))  # Second number
	print("received %s (exit code: %s), extracted %s, %s" % [stdout[0], exit_code, x, y])
	return Vector2i(x, y)
