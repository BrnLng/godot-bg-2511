extends Node

signal turn_passed
# signal turn_started
# signal turn_ended
# signal trigger_phase
# signal next_phase
# signal next_round
# signal turn_changed(player_id)


func pass_next() -> void:
	turn_passed.emit()
