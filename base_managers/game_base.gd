class_name GameBase
extends Node2D

enum PlayerRef { NONE, PLAYER_1, PLAYER_2 }
# enum PlayerPresence { NONE, PLAYER }
var current_player: PlayerRef  #PlayerPresence
# var players_types: Vector2  # x = Human players, y = Computer
# var players: Array[int]
# var player_queue: Array[int]
# var scoreboard: Dictionary
# signal game_ended(winner, score)
var is_game_over: bool = false



func _ready() -> void:
	# randomize()
	initialize_base_game()


func initialize_base_game() -> void:
	TurnManager.turn_passed.connect(_on_turn_passed)
	reset_game()


func reset_game() -> void:
	current_player = PlayerRef.PLAYER_1
	is_game_over = false


func get_current_player() -> PlayerRef:  # PlayerPresence:
	return current_player


func player_count() -> int:
	return PlayerRef.size() -1
	# return players.size()


func is_player_turn(player_id) -> bool:
	if get_current_player() == player_id:
		return true
	return false


func pass_turn() -> void:
	TurnManager.pass_next()


func _on_turn_passed() -> void:
	# if player_queue:
		# player_queue.append(current_player)
		# current_player = player_queue.pop()
	# else:
	# current_player = (current_player + 1) % player_count()
	# current_player = PlayerPresence.PLAYER_2 if current_player == PlayerPresence.PLAYER_1 else PlayerPresence.PLAYER_1
	switch_player()


func switch_player() -> void:
	current_player = PlayerRef.PLAYER_2 if current_player == PlayerRef.PLAYER_1 else PlayerRef.PLAYER_1


# func collect_player_choice(player_id, choice):
	# choices[player_id] = choice
	# if choices.size() == player_count:
		# resolve_round()
		# reset_choices()


# func _on_game_ended(player_id, score) -> void:
# 	scoreboard[score] = player_id
