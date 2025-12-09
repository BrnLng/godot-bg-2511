extends Node

signal turn_passed
signal turn_started
signal turn_ended
# signal trigger_phase
# signal next_phase
# signal next_round
# signal turn_changed(player_id)

var turn_counter: int = 1
var _in_turn_counter: int = 0
var in_turn_counter: String: get=get_in_turn_counter


func get_in_turn_counter() -> String:
	var base_counter = "%02d" % turn_counter
	_in_turn_counter += 1
	if _in_turn_counter < 2:
		return str(base_counter)
	return base_counter + "." + "%02d" % _in_turn_counter


func pass_next(manage_turn_end:Script=null) -> void:
	turn_passed.emit()
	if manage_turn_end:
		await manage_turn_end.process()  # TODO: implement this
		end_turn()
	turn_counter += 1


func start_turn() -> void:
	_in_turn_counter = 0
	turn_started.emit()


func end_turn() -> void:
	turn_ended.emit()


# func trigger_next_phase() -> void:
# 	trigger_phase.emit()


# func next_phase() -> void:
# 	next_phase.emit()


# func next_round() -> void:
# 	next_round.emit()


# func change_turn(player_id) -> void:
# 	turn_changed.emit(player_id)
