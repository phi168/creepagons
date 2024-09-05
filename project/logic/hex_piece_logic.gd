# HexGridLogic.gd
extends Node

class_name HexPieceLogic

var _owner: int = 0  # 0 means unoccupied, 1 for player 1, 2 for player 2
var health: int = 0
var max_health: int = 1
var health_delta := {1: 0, 2: 0}
var rendered_text := ""

func add_health(delta: int, is_attack: bool):
	health += delta
	if health < 0:
		if is_attack:
			_owner = (_owner % 2) + 1 # 2->1; 1->2
			health *= -1
		else:
			health = 0
	if health > max_health:
		health = max_health
	if health == 0: # nobody can own dead tiles
		_owner = 0
	if _owner == 0: # unowned tiles can't have finite health
		health = 0
		
func add_health_delta(delta: int, player_id: int):
	health_delta[player_id] += delta
	rendered_text = health_to_string(health_delta[1]) + '    ' + health_to_string(health_delta[2])
			
func health_to_string(health_delta: int):
	if health_delta == 0:
		return ' ' 
	else:
		return str(health_delta)
func apply_health_delta():
	# then we diff the rest and assign new _owner
	# we assume there can only be 2 players
	# health delta can only be negative for the current _owner
	var delta:int
	var is_attack:= false
	if _owner == 1:
		delta = health_delta[1] - clamp(health_delta[2], 0, 3)
		is_attack = health_delta[2] > 0
	elif _owner == 2:
		delta = health_delta[2] - clamp(health_delta[1], 0, 3)
		is_attack = health_delta[1] > 0
	elif _owner == 0:
		
		delta = clamp(health_delta[1], 0, 3) - clamp(health_delta[2], 0, 3)
		if delta > 0:
			_owner = 1
		elif delta < 0: 
			_owner = 2
			delta *= -1
	# reset
	health_delta = {1: 0, 2: 0}


	add_health(delta, is_attack)
