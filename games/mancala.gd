extends GameBase

@onready var player1_pit_store: Button = %P1Store as TileComponent
@onready var player2_pit_store: Button = %P2Store as TileComponent
@onready var status_label: Label = %StatusLabel

# loop path board: 6 pits per player + 2 stores -- running anti-clockwise.
# Index 0 starting at Player 2's bottom row
# Indices 0-5: Player 2 pits, 6: Player 2 store
# Indices 7-12: Player 1 pits, 13: Player 1 store
var seeds_count: Array[int] = [4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 0]
const P2STORE = 6
const P1STORE = 13
var pit_tiles: Array[TileComponent] = []


func _ready():
	setup_buttons()
	update_display()


func setup_buttons():
	# Get all pit buttons
	var player1_pits_container = %PitTopContainer
	var player2_pits_container = %PitBottomContainer
	
	pit_tiles.resize(14) # We'll use indices to match the board
	
	# Player 2 pits (indices 0-5)
	player2_pit_store.region_index = P2STORE
	pit_tiles[P2STORE] = player2_pit_store
	for i in range(6):
		var tile = player2_pits_container.get_child(i) as TileComponent
		tile.region_index = i
		pit_tiles[i] = tile
		tile.is_clicked.connect(_on_pit_clicked)
	
	# Player 1 pits (indices 7-12, but buttons are in reverse order)
	player1_pit_store.region_index = P1STORE
	pit_tiles[P1STORE] = player1_pit_store
	for i in range(6):
		var tile = player1_pits_container.get_child(5-i) as TileComponent
		var board_index = i + 7
		tile.region_index = board_index
		pit_tiles[board_index] = tile
		tile.is_clicked.connect(_on_pit_clicked)


func _on_pit_clicked(pit_index: int):
	if is_game_over or not is_valid_move(pit_index):
		return
	
	make_move(pit_index)
	update_display()
	
	if check_empty_pit_row():
		end_game()


func is_valid_move(pit_index: int) -> bool:
	# Check if it's the current player's pit and has seeds
	if current_player == PlayerRef.PLAYER_2:
		return pit_index >= 0 and pit_index <= 5 and seeds_count[pit_index] > 0
	else:  # PlayerRef.PLAYER_1:
		return pit_index >= 7 and pit_index <= 12 and seeds_count[pit_index] > 0


func make_move(pit_index: int):
	var seeds = seeds_count[pit_index]
	seeds_count[pit_index] = 0
	
	var current_pit = pit_index
	
	# Distribute seeds
	while seeds > 0:
		current_pit = (current_pit + 1) % 14
		
		# Skip opponent's store
		if (current_player == PlayerRef.PLAYER_1 and current_pit == P2STORE) or \
		   (current_player == PlayerRef.PLAYER_2 and current_pit == P1STORE):
			continue
		
		seeds_count[current_pit] += 1
		seeds -= 1
	
	# Check for capture
	check_capture(current_pit)
	
	# Check if last seed landed in own store (extra turn)
	var own_store = P1STORE if current_player == PlayerRef.PLAYER_1 else P2STORE
	if current_pit != own_store:
		pass_turn()


func check_capture(last_pit: int):
	# Only capture if last seed landed in own empty pit
	if seeds_count[last_pit] != 1:
		return
	
	var own_store: int
	if current_player == PlayerRef.PLAYER_2 and last_pit >= 0 and last_pit <= 5:
		own_store = P2STORE
	elif current_player == PlayerRef.PLAYER_1 and last_pit >= 7 and last_pit <= 12:
		own_store = P1STORE
	else:
		return
	
	var opposite_pit = 12 - last_pit
	# Capture seeds from opposite pit
	if seeds_count[opposite_pit] > 0:
		seeds_count[own_store] += seeds_count[last_pit] + seeds_count[opposite_pit]
		seeds_count[last_pit] = 0
		seeds_count[opposite_pit] = 0


func check_empty_pit_row() -> bool:
	var player1_empty = true
	var player2_empty = true
	
	# Check if Player 1 has any seeds
	for i in range(7, 13):
		if seeds_count[i] > 0:
			player1_empty = false
			break
	
	# Check if Player 2 has any seeds
	for i in range(6):
		if seeds_count[i] > 0:
			player2_empty = false
			break
	
	return player1_empty or player2_empty


func end_game():
	is_game_over = true
	
	# Move remaining seeds to respective stores
	for i in range(6):
		seeds_count[P2STORE] += seeds_count[i]
		seeds_count[i] = 0
	
	for i in range(7, 13):
		seeds_count[P1STORE] += seeds_count[i]
		seeds_count[i] = 0
	
	update_display()
	
	# Determine winner
	var winner_text = ""
	if seeds_count[P2STORE] > seeds_count[P1STORE]:
		winner_text = "Player 2 Wins!"
	elif seeds_count[13] > seeds_count[6]:
		winner_text = "Player 1 Wins!"
	else:
		winner_text = "It's a Tie!"
	
	status_label.text = winner_text


func update_display():
	# Update pit tiles
	# Player 2 pits (0-5)
	for i in range(6):
		pit_tiles[i].text = str(seeds_count[i])
		pit_tiles[i].disabled = is_game_over or current_player != PlayerRef.PLAYER_2 or seeds_count[i] == 0

	# Player 1 pits (7-12)
	for i in range(7, 13):
		pit_tiles[i].text = str(seeds_count[i])
		pit_tiles[i].disabled = is_game_over or current_player != PlayerRef.PLAYER_1 or seeds_count[i] == 0

	# Update stores
	player1_pit_store.text = "P1 Store:\n" + str(seeds_count[P1STORE])
	player2_pit_store.text = "P2 Store:\n" + str(seeds_count[P2STORE])
	
	# Update status
	if not is_game_over:
		var player_name = "Player 1" if current_player == PlayerRef.PLAYER_1 else "Player 2"
		status_label.text = player_name + "'s Turn"


func _on_restart_pressed():
	reset_game()
	update_display()
