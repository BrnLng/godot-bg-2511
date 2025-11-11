class_name BaseSlot
extends BaseRegion

const GRID_SLOT_MIN_SIZE = Vector2(64, 64)

var player_owner := GameBase.PlayerRef.NONE : set=_set_player_owner, get=_get_player_owner


func _ready():
	custom_minimum_size = GRID_SLOT_MIN_SIZE
	_reset_game()


func _reset_game():
	_set_player_owner(GameBase.PlayerRef.NONE)
	disabled = false
	text = ""


func _set_player_owner(new_owner: GameBase.PlayerRef) -> void:
	player_owner = new_owner


func _get_player_owner() -> GameBase.PlayerRef:
	return player_owner