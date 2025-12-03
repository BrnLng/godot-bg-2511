class_name GameBase
extends Node2D

signal _show_message(msg:String)
signal _add_history(msg:String)
signal _to_panel_item(item:Node)

enum PlayerRef { NONE=-1, ANY=0, PLAYER_1=1, PLAYER_2=2 }
var current_player: PlayerRef : get=get_current_player
var last_player: PlayerRef : get=get_last_player
var next_player: PlayerRef : get=get_next_player

var player_score: Array[int] = [-1, 0, 0]  # [AVAILABLE, PLAYER_1, PLAYER_2]

var is_game_over: bool = false
# var game_count: int = 1
var games_won: Vector2i = Vector2i.ZERO
var best_of_threshold: int = 3
var best_of_taken: bool = false

var _plugged_hud: CanvasLayer

# TODO: implement later:
# var players_types: Vector2  # x = Human players, y = Computer
# var players: Array[int]
# var player_queue: Array[int]
# var scoreboard: Dictionary
# signal game_ended(winner, score)


func _ready() -> void:
	# TODO: add randomize() some time later with fixed seed option
	_initialize_base_game()


func plug(where:String, what:Variant) -> void:
	if where == "hud":
		_plugged_hud = what


func _initialize_base_game() -> void:
	TurnManager.turn_passed.connect(_on_turn_passed)
	TurnManager.turn_started.connect(_on_turn_started)
	# TODO: implement later:
	# TurnManager.turn_ended.connect(_on_turn_ended)
	# TurnManager.trigger_phase.connect(_on_trigger_phase)
	# TurnManager.next_phase.connect(_on_next_phase)
	# TurnManager.next_round.connect(_on_next_round)
	# TurnManager.turn_changed.connect(_on_turn_changed)
	reset_game()


func reset_game() -> void:
	current_player = PlayerRef.PLAYER_1
	is_game_over = false
	# game_count = 1
	games_won = Vector2i.ZERO
	best_of_threshold = 3
	reset_scores()


func add_score(player:PlayerRef, score:int=1) -> void:
	player_score[player] += score


func get_score(player:PlayerRef) -> int:
	return player_score[player]


func reset_scores() -> void:
	player_score[PlayerRef.PLAYER_1] = 0
	player_score[PlayerRef.PLAYER_2] = 0


func _on_turn_passed() -> void:
	_switch_player()
	TurnManager.start_turn()


func _on_turn_started() -> void:
	show_message("It's Player " + str(current_player) + "'s turn")


# TODO: implement func _on_turn_ended() -> void: pass


func _switch_player() -> void:
	# TODO: implement if player_queue:
		# player_queue.append(current_player)
		# current_player = player_queue.pop()
	# else:
	# current_player = (current_player + 1) % player_count()
	last_player = current_player
	current_player = get_next_player()


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


func show_message(msg:String) -> void:
	_show_message.emit(msg)


func add_history(msg:String) -> void:
	_add_history.emit(msg)


func to_panel_item(item:Node) -> void:
	_to_panel_item.emit(item)


func get_panel_item() -> Node:
	if not _plugged_hud:
		return
	return _plugged_hud.get_hud_panel_node()


## Determine high score to calculate the current "best of" series.
# TODO: Debug counters (sometimes it counts correctly, not always)
func get_game_round_best_of(score_a, score_b) -> String:
	var max_score_reached = max(score_a, score_b)
	if (max_score_reached == best_of_threshold) or (max_score_reached == best_of_threshold + 2) \
		and not best_of_taken:
		if score_a > score_b:
			games_won = Vector2i(games_won.x + 1, games_won.y)
		else:
			games_won = Vector2i(games_won.x, games_won.y + 1)
		best_of_taken = true
	if max_score_reached == best_of_threshold + 2:
		best_of_threshold += 2
		best_of_taken = false

	return "(%d x %d) in best of %d" % [games_won.x, games_won.y, best_of_threshold]


# TODO: implement func collect_player_choice(player_id, choice):
	# choices[player_id] = choice
	# if choices.size() == player_count:
		# resolve_round()
		# reset_choices()


# TODO: implement func _on_game_ended(player_id, score) -> void:
# 	scoreboard[score] = player_id
