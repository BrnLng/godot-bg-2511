extends GameBase

var board: Array[int] = []
var game_over: bool = false

@onready var player1_store: Button = %P1Store
@onready var player2_store: Button = %P2Store
@onready var status_label: Label = %StatusLabel

var pit_buttons: Array[Button] = []

func _ready():
	TurnManager.turn_passed.connect(_on_turn_passed)
	initialize_game()
	setup_buttons()
	update_display()


func initialize_game():
	# Initialize board: 6 pits per player + 2 stores
	# Note: running anti-clockwise.
	# Index 0 starting at Player 2's bottom row
	# Indices 0-5: Player 2 pits, 6: Player 2 store
	# Indices 7-12: Player 1 pits, 13: Player 1 store
	board = [4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 0]
	current_player = Player.PLAYER_1
	game_over = false


func setup_buttons():
	# Get all pit buttons
	var player1_container = %PitTopContainer
	var player2_container = %PitBottomContainer
	
	pit_buttons.resize(14) # We'll use indices to match the board
	
	# Player 2 pits (indices 0-5)
	for i in range(6):
		var button = player2_container.get_child(i)
		pit_buttons[i] = button
		button.pressed.connect(_on_pit_clicked.bind(i))
	
	# Player 1 pits (indices 7-12, but buttons are in reverse order)
	for i in range(6):
		var button = player1_container.get_child(5-i)
		var board_index = i + 7
		pit_buttons[board_index] = button
		button.pressed.connect(_on_pit_clicked.bind(i + 7))


func _on_pit_clicked(pit_index: int):
	# print("on pit clicked")
	# print("is game over? = ", game_over)
	if game_over:
		return
	
	# print("is move valid? = ", is_valid_move(pit_index))
	if not is_valid_move(pit_index):
		return
	
	make_move(pit_index)
	update_display()
	
	if check_game_over():
		end_game()

func is_valid_move(pit_index: int) -> bool:
	# Check if it's the current player's pit and has seeds
	if current_player == Player.PLAYER_2:
		return pit_index >= 0 and pit_index <= 5 and board[pit_index] > 0
	else:
		return pit_index >= 7 and pit_index <= 12 and board[pit_index] > 0

func make_move(pit_index: int):
	var seeds = board[pit_index]
	board[pit_index] = 0
	
	var current_pit = pit_index
	
	# Distribute seeds
	while seeds > 0:
		current_pit = (current_pit + 1) % 14
		
		# Skip opponent's store
		if (current_player == Player.PLAYER_1 and current_pit == 6) or \
		   (current_player == Player.PLAYER_2 and current_pit == 13):
			continue
		
		board[current_pit] += 1
		seeds -= 1
	
	# Check for capture
	check_capture(current_pit)
	
	# Check if last seed landed in own store (extra turn)
	var own_store = 13 if current_player == Player.PLAYER_1 else 6
	if current_pit != own_store:
		TurnManager.pass_next()  # switch_player()

func check_capture(last_pit: int):
	# Only capture if last seed landed in own empty pit
	if board[last_pit] != 1:
		return
	
	var opposite_pit = -1
	var own_store = -1
	
	if current_player == Player.PLAYER_2 and last_pit >= 0 and last_pit <= 5:
		opposite_pit = 12 - last_pit
		own_store = 6
	elif current_player == Player.PLAYER_1 and last_pit >= 7 and last_pit <= 12:
		opposite_pit = 12 - last_pit
		own_store = 13
	
	if opposite_pit >= 0 and board[opposite_pit] > 0:
		# Capture seeds
		board[own_store] += board[last_pit] + board[opposite_pit]
		board[last_pit] = 0
		board[opposite_pit] = 0

func _on_turn_passed() -> void:  # switch_player():
	current_player = Player.PLAYER_2 if current_player == Player.PLAYER_1 else Player.PLAYER_1

func check_game_over() -> bool:
	var player1_empty = true
	var player2_empty = true
	
	# Check if Player 1 has any seeds
	for i in range(7, 13):
		if board[i] > 0:
			player1_empty = false
			break
	
	# Check if Player 2 has any seeds
	for i in range(6):
		if board[i] > 0:
			player2_empty = false
			break
	
	return player1_empty or player2_empty

func end_game():
	game_over = true
	
	# Move remaining seeds to respective stores
	for i in range(6):
		board[6] += board[i]
		board[i] = 0
	
	for i in range(7, 13):
		board[13] += board[i]
		board[i] = 0
	
	# Determine winner
	var winner_text = ""
	if board[6] > board[13]:
		winner_text = "Player 2 Wins!"
	elif board[13] > board[6]:
		winner_text = "Player 1 Wins!"
	else:
		winner_text = "It's a Tie!"
	
	status_label.text = winner_text

func update_display():
	# Update pit buttons
	# Player 2 pits (0-5)
	for i in range(6):
		pit_buttons[i].text = str(board[i])
		pit_buttons[i].disabled = game_over or current_player != Player.PLAYER_2 or board[i] == 0

	# Player 1 pits (7-12)
	for i in range(7, 13):
		pit_buttons[i].text = str(board[i])
		pit_buttons[i].disabled = game_over or current_player != Player.PLAYER_1 or board[i] == 0

	# Update stores
	player1_store.text = "P1 Store: " + str(board[13])
	player2_store.text = "P2 Store: " + str(board[6])
	
	# Update status
	if not game_over:
		var player_name = "Player 1" if current_player == Player.PLAYER_1 else "Player 2"
		status_label.text = player_name + "'s Turn"

func _on_restart_pressed():
	initialize_game()
	update_display()
