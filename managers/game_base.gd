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
var game_counter: int = 1
var last_best_threshold: int = 1
var game_results: Vector2i = Vector2i.ZERO


func _ready() -> void:
	# TODO: add randomize() some time later with fixed seed option
	_initialize_base_game()


func get_game_round_best_of(score_a, score_b) -> String:
	# Determine the highest score to calculate the current "best of" series.
	var max_score_reached = max(score_a, score_b)
	var scores_added = score_a + score_b
	# The number of wins needed is one or two more than the current max score.
	# The "best of" threshold is always an odd number, calculated as 2 * wins_needed - 1.
	var cur_best_threshold = max_score_reached + 2 if \
		( (max_score_reached != 0) or (scores_added - max_score_reached > 1) ) else 1
	# var cur_best_threshold = 2 * wins_needed - 1

	if last_best_threshold != cur_best_threshold:
		game_counter += 1
		game_results = Vector2i(score_a, score_b)
		last_best_threshold = cur_best_threshold

	return "(%d x %d) in best of %d" % [game_results.x, game_results.y, cur_best_threshold]


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


func get_current_player() -> PlayerRef:
	return current_player


func get_last_player() -> PlayerRef:
	return last_player


func get_next_player() -> PlayerRef:
	return PlayerRef.PLAYER_2 if current_player == PlayerRef.PLAYER_1 else PlayerRef.PLAYER_1


#func player_count() -> int:
	#return PlayerRef.size() -3
	# return players.size()


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
