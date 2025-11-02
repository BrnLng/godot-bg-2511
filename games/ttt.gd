extends Node2D
#extends Control

@onready var grid_container = %TTTGridContainer
var buttons: Array[TicTacToeButton] = []
var current_player: TicTacToeButton.CellState = TicTacToeButton.CellState.PLAYER_1
var game_over: bool = false

func _ready():
	setup_game()

func setup_game():
	for i in range(grid_container.get_child_count()):
		var button = grid_container.get_child(i) as TicTacToeButton
		print(button.name)
		if button:
			button.cell_index = i
			button.cell_clicked.connect(_on_cell_clicked)
			buttons.append(button)

func _on_cell_clicked(index: int):
	if game_over or buttons[index].cell_state != TicTacToeButton.CellState.INIT:
		return
	
	buttons[index].set_state(current_player)
	
	if check_winner():
		game_over = true
		disable_all_buttons()
		print("Player ", current_player, " wins!")
	elif is_board_full():
		game_over = true
		print("It's a draw!")
	else:
		switch_player()

func check_winner() -> bool:
	var winning_combinations = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8],  # Rows
		[0, 3, 6], [1, 4, 7], [2, 5, 8],  # Columns
		[0, 4, 8], [2, 4, 6]              # Diagonals
	]
	
	for combo in winning_combinations:
		var first_state = buttons[combo[0]].cell_state
		if first_state != TicTacToeButton.CellState.INIT and \
		   first_state == buttons[combo[1]].cell_state and \
		   first_state == buttons[combo[2]].cell_state:
			return true
	
	return false

func is_board_full() -> bool:
	for button in buttons:
		if button.cell_state == TicTacToeButton.CellState.INIT:
			return false
	return true

func switch_player():
	current_player = TicTacToeButton.CellState.PLAYER_2 if current_player == TicTacToeButton.CellState.PLAYER_1 else TicTacToeButton.CellState.PLAYER_1

func disable_all_buttons():
	for button in buttons:
		if button.cell_state == TicTacToeButton.CellState.INIT:
			button.disabled = true

func reset_game():
	game_over = false
	current_player = TicTacToeButton.CellState.PLAYER_1
	
	for button in buttons:
		button.reset()

# old code
#@onready var button_1: Button = %Button1
#@onready var button_2: Button = %Button2
#@onready var button_3: Button = %Button3
#@onready var button_4: Button = %Button4
#@onready var button_5: Button = %Button5
#@onready var button_6: Button = %Button6
#@onready var button_7: Button = %Button7
#@onready var button_8: Button = %Button8
#@onready var button_9: Button = %Button9
#
#
#func _ready() -> void:
	#var c = 1
	#for cell in get_tree().get_nodes_in_group("available_cell"):
		#cell.pressed.connect(_on_cell_selected.bind(c))
		#c += 1
#
#
#func _on_cell_selected(pos) -> void:
	#print("cell selected: ", pos)
