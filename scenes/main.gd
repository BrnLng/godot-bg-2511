extends  Node2D

# Define an enum for the game choices that will appear in the editor's dropdown.
enum GameLoaded {
	ROCK_PAPER_SCISSORS,
	TIC_TAC_TOE,
	MANCALA,
	MINI_CARCASSONE,
}

# Map the enum values to the actual scene file paths.
const GAME_SCENES = {
	GameLoaded.ROCK_PAPER_SCISSORS: "res://games/01_rock_paper_scissors.tscn",
	GameLoaded.TIC_TAC_TOE: "res://games/02_tic_tac_toe.tscn",
	GameLoaded.MANCALA: "res://games/03_mancala.tscn",
	GameLoaded.MINI_CARCASSONE: "res://games/04_mini_carcassone.tscn",
}

@export var selected_game: GameLoaded = GameLoaded.TIC_TAC_TOE

# var history_counter: int = 1
var _game: GameBase

@onready var _hud: CanvasLayer = $HUD


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
	_game._hud_message.connect(_hud._on_hud_message_update)
	_game._hud_history.connect(_hud._on_hud_history_update)
	_game._hud_panel.connect(_hud._on_hud_panel_update)
