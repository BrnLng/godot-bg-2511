class_name BaseComponent
extends Button

var player_owner := GameBase.Player.NONE : set=set_player_owner, get=get_player_owner
var region_index: int = -1 : set=set_region_index, get=get_region_index

signal is_clicked(index: int)


func _ready():
	custom_minimum_size = Vector2(64, 64)

	pressed.connect(_on_pressed)
	reset()


func _on_pressed():
	is_clicked.emit(region_index)


func set_player_owner(new_owner: GameBase.Player) -> void:
	player_owner = new_owner


func get_player_owner() -> GameBase.Player:
	return player_owner


func set_region_index(new_index: int) -> void:
	region_index = new_index


func get_region_index() -> int:
	return region_index


func reset():
	set_player_owner(GameBase.Player.NONE)
	disabled = false
	text = ""
