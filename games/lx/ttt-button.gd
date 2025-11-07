class_name TicTacToeButton
extends Button

# enum CellState { INIT, PLAYER_1, PLAYER_2 }

var cell_state := GameBase.Player.NONE
var cell_index: int = -1

signal cell_clicked(index: int)

func _ready():
	pressed.connect(_on_pressed)
	update_appearance()

func _on_pressed():
	cell_clicked.emit(cell_index)

func set_state(new_state: GameBase.Player):
	cell_state = new_state
	update_appearance()

func update_appearance():
	match cell_state:
		GameBase.Player.NONE:
			text = ""
			disabled = false
		GameBase.Player.PLAYER_1:
			text = "1"
			disabled = true
		GameBase.Player.PLAYER_2:
			text = "2"
			disabled = true

func reset():
	set_state(GameBase.Player.NONE)
