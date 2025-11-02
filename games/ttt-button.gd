class_name TicTacToeButton
extends Button

enum CellState { INIT, PLAYER_1, PLAYER_2 }

var cell_state: CellState = CellState.INIT
var cell_index: int = -1

signal cell_clicked(index: int)

func _ready():
	pressed.connect(_on_pressed)
	update_appearance()

func _on_pressed():
	cell_clicked.emit(cell_index)

func set_state(new_state: CellState):
	cell_state = new_state
	update_appearance()

func update_appearance():
	match cell_state:
		CellState.INIT:
			text = ""
			disabled = false
		CellState.PLAYER_1:
			text = "X"
			disabled = true
		CellState.PLAYER_2:
			text = "O"
			disabled = true

func reset():
	set_state(CellState.INIT)
