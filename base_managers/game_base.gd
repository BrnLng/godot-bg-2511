class_name GameBase
extends Node2D

enum Player { NONE, PLAYER_1, PLAYER_2 }
# enum PlayerPresence { NONE, PLAYER }
var current_player: Player  #PlayerPresence
# var players_types: Vector2  # x = Human players, y = Computer
# var players: Array[int]
# var player_queue: Array[int]
# var scoreboard: Dictionary
# signal game_ended(winner, score)


func _ready() -> void:
	TurnManager.turn_passed.connect(_on_turn_passed)


func get_current_player() -> Player:  # PlayerPresence:
	return current_player


func player_count() -> int:
	return Player.size() -1
	# return players.size()


func is_player_turn(player_id) -> bool:
	if get_current_player() == player_id:
		return true
	return false


func _on_turn_passed() -> void:
	# if player_queue:
		# player_queue.append(current_player)
		# current_player = player_queue.pop()
	# else:
	# current_player = (current_player + 1) % player_count()
	# current_player = PlayerPresence.PLAYER_2 if current_player == PlayerPresence.PLAYER_1 else PlayerPresence.PLAYER_1
	current_player = Player.PLAYER_2 if current_player == Player.PLAYER_1 else Player.PLAYER_1


# func collect_player_choice(player_id, choice):
	# choices[player_id] = choice
	# if choices.size() == player_count:
		# resolve_round()
		# reset_choices()


# func _on_game_ended(player_id, score) -> void:
# 	scoreboard[score] = player_id
