extends  Node2D

@onready var label_left: Label = %LabelLeft
@onready var mid_panel: Control = %MidPanel
@onready var label_right: Label = %LabelRight

var _game: GameBase


func _ready() -> void:
	_game = get_children()[0] as GameBase
	if not _game:
		print("Error: game connect error @ main")
	
	print(_game.name)
	_on_hud_message_update("test msg")
	_on_hud_history_update("test hist")

	_game.hud_message.connect(_on_hud_message_update)
	_game.hud_history.connect(_on_hud_history_update)
	_game.hud_panel.connect(_on_hud_panel_update)


func _on_hud_message_update(msg:String) -> void:
	label_left.text = msg


func _on_hud_history_update(msg:String) -> void:
	label_right.text = msg


func _on_hud_panel_update(item:Node) -> void:
	mid_panel.add_child(item)
