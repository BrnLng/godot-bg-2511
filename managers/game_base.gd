class_name GameBase
extends Node2D

signal _hud_message(msg:String)
signal _hud_history(msg:String)
signal _hud_panel(item:Node)

enum PlayerRef { NONE=-1, ANY=0, PLAYER_1=1, PLAYER_2=2 }
var current_player: PlayerRef : get=get_current_player
var last_player: PlayerRef : get=get_last_player
var next_player: PlayerRef : get=get_next_player
# var players_types: Vector2  # x = Human players, y = Computer
# var players: Array[int]
# var player_queue: Array[int]
# var scoreboard: Dictionary
# signal game_ended(winner, score)
var is_game_over: bool = false
var game_count: int = 1
var games_won: Vector2i = Vector2i.ZERO
var best_of_threshold: int = 1


func _ready() -> void:
	# TODO: add randomize() some time later with fixed seed option
	_initialize_base_game()


func get_game_round_best_of(score_a, score_b) -> String:
	# Determine the highest score to calculate the current "best of" series.
	var max_score_reached = max(score_a, score_b)
	if max_score_reached == best_of_threshold:
		game_count += 1
		if score_a > score_b:
			games_won = Vector2i(games_won.x + 1, games_won.y)
		else:
			games_won = Vector2i(games_won.x, games_won.y + 1)
		# games_won = Vector2i(score_a, score_b)
		# game_results = Vector2i(score_a, score_b)
		best_of_threshold = best_of_threshold + 2

	return "(%d x %d) in best of %d" % [games_won.x, games_won.y, best_of_threshold]


func _initialize_base_game() -> void:
	TurnManager.turn_passed.connect(_on_turn_passed)
	TurnManager.turn_started.connect(_on_turn_started)
	# TurnManager.turn_ended.connect(_on_turn_ended)
	# TurnManager.trigger_phase.connect(_on_trigger_phase)
	# TurnManager.next_phase.connect(_on_next_phase)
	# TurnManager.next_round.connect(_on_next_round)
	# TurnManager.turn_changed.connect(_on_turn_changed)
	reset_game()


func _on_turn_passed() -> void:
	_switch_player()
	TurnManager.start_turn()


func _on_turn_started() -> void:
	hud_message("It's Player " + str(current_player) + "'s turn")


# func _on_turn_ended() -> void:


func _switch_player() -> void:
	# if player_queue:
		# player_queue.append(current_player)
		# current_player = player_queue.pop()
	# else:
	# current_player = (current_player + 1) % player_count()
	# current_player = PlayerPresence.PLAYER_2 if current_player == PlayerPresence.PLAYER_1 else PlayerPresence.PLAYER_1
	last_player = current_player
	current_player = get_next_player()


func reset_game() -> void:
	current_player = PlayerRef.PLAYER_1
	is_game_over = false
	game_count = 1
	best_of_threshold = 1
	games_won = Vector2i.ZERO


func get_current_player() -> PlayerRef:
	return current_player


func get_last_player() -> PlayerRef:
	return last_player


func get_next_player() -> PlayerRef:
	return PlayerRef.PLAYER_2 if current_player == PlayerRef.PLAYER_1 else PlayerRef.PLAYER_1


func is_player_turn(player_id) -> bool:
	if get_current_player() == player_id:
		return true
	return false


func pass_turn() -> void:
	TurnManager.pass_next()


# func collect_player_choice(player_id, choice):
	# choices[player_id] = choice
	# if choices.size() == player_count:
		# resolve_round()
		# reset_choices()


# func _on_game_ended(player_id, score) -> void:
# 	scoreboard[score] = player_id


func hud_message(msg:String) -> void:
	_hud_message.emit(msg)


func hud_history(msg:String) -> void:
	_hud_history.emit(msg)


func hud_panel_show(item:Node) -> void:
	_hud_panel.emit(item)
