extends Node

signal turn_passed
signal turn_started
# signal turn_ended
# signal trigger_phase
# signal next_phase
# signal next_round
# signal turn_changed(player_id)


func pass_next() -> void:
	turn_passed.emit()


func start_turn() -> void:
	turn_started.emit()


# func end_turn() -> void:
# 	turn_ended.emit()


# func trigger_next_phase() -> void:
# 	trigger_phase.emit()


# func next_phase() -> void:
# 	next_phase.emit()


# func next_round() -> void:
# 	next_round.emit()


# func change_turn(player_id) -> void:
# 	turn_changed.emit(player_id)
