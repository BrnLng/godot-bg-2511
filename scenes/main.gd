extends  Node2D

# Define an enum for the game choices that will appear in the editor's dropdown.
enum Game {
	ROCK_PAPER_SCISSORS,
	TIC_TAC_TOE,
	MANCALA,
	MINI_CARCASSONE,
}

# Map the enum values to the actual scene file paths.
const GAME_SCENES = {
	Game.ROCK_PAPER_SCISSORS: "res://games/01_rock_paper_scissors.tscn",
	Game.TIC_TAC_TOE: "res://games/02_tic_tac_toe.tscn",
	Game.MANCALA: "res://games/03_mancala.tscn",
	Game.MINI_CARCASSONE: "res://games/04_mini_carcassone.tscn",
}

@export var selected_game: Game = Game.TIC_TAC_TOE

@onready var label_left: Label = %LabelLeft
@onready var mid_panel: Control = %MidPanel
@onready var label_right: RichTextLabel = %LabelRight
# @onready var history_scroll: ScrollContainer = label_right.get_parent() as ScrollContainer

var history_counter: int = 1
var _game: GameBase


func _ready() -> void:
	var game_scene_path = GAME_SCENES.get(selected_game)
	if not game_scene_path:
		push_error("No scene path found for the selected game in main.gd!")
		return
	
	var game_scene: PackedScene = load(game_scene_path)
	if not game_scene:
		push_error("Failed to load game scene at path: " + game_scene_path)
		return
		
	_game = game_scene.instantiate() as GameBase
	if not _game:
		push_error("Instantiated game scene does not have a GameBase root script!")
		return

	$GamePlug.add_child(_game)

	# Now connect the signals from the actual game instance
	_game._hud_message.connect(self._on_hud_message_update)
	_game._hud_history.connect(self._on_hud_history_update)
	_game._hud_panel.connect(self._on_hud_panel_update)


func _on_hud_message_update(msg:String) -> void:
	label_left.text = msg


func _on_hud_history_update(msg:String) -> void:
	label_right.text = "[color=DIM_GRAY]" + ("%03d" % history_counter) + ".[/color] " + msg + "  \n" + label_right.text
	history_counter += 1
	# The scrollbar's max_value is not updated in the same frame the label's text is changed.
	# We need to wait for the next idle frame for the container to resize and update the scrollbar.
	# call_deferred("_scroll_history_to_bottom")
	#label_right.scroll_to_line(history_counter)


# func _scroll_history_to_bottom() -> void:
# 	history_scroll.scroll_vertical = int(history_scroll.get_v_scroll_bar().max_value)


func _on_hud_panel_update(item:Node) -> void:
	Utils.remove_all_children(mid_panel)
	mid_panel.add_child(item)
