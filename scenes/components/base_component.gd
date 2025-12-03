class_name BaseComponent
extends Button

signal is_clicked(index: int)

enum RotationAngle { ROT_0 = 0, ROT_90 = 90, ROT_180 = 180, ROT_270 = 270 }
enum RotationDirection { ROT_TOP = 0, ROT_LEFT = 270, ROT_DOWN = 180, ROT_RIGHT = 90 }

var player_owner := GameBase.PlayerRef.NONE : set=set_player_owner, get=get_player_owner
var region_index: int = -1 : set=set_region_index, get=get_region_index


func _ready():
	custom_minimum_size = Vector2(64, 64)

	pressed.connect(_on_pressed)
	reset()


func _on_pressed():
	is_clicked.emit(region_index)


func set_player_owner(new_owner: GameBase.PlayerRef) -> void:
	player_owner = new_owner


func get_player_owner() -> GameBase.PlayerRef:
	return player_owner


func set_region_index(new_index: int) -> void:
	region_index = new_index


func get_region_index() -> int:
	return region_index


func rotate(to: RotationDirection) -> void:
	rotation_degrees = int(to)


func reset():
	set_player_owner(GameBase.PlayerRef.NONE)
	disabled = false
	text = ""
