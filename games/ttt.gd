extends GameBase

@onready var grid_container = %TTTGridContainer
var tiles: Array[GridSlotIndexedRegion] = []
var game_over: bool = false

var grid_size: int = 3


func _ready():
	super._ready()
	setup_grid()

func setup_grid():
	grid_container.columns = grid_size
	for i in range(grid_size * grid_size):
		var tile = GridSlotIndexedRegion.new()
		if tile:
			tile.region_index = i
			tile.is_clicked.connect(_on_tile_clicked)
			tiles.append(tile)
		grid_container.add_child(tile)

func _on_tile_clicked(index: int):
	if is_game_over or tiles[index].player_owner != PlayerRef.NONE \
		or index < 0 or index >= len(tiles):
		print("Invalid move")
		return
	
	tiles[index].set_player_owner(current_player)
	match tiles[index].player_owner:
		PlayerRef.PLAYER_1:
			tiles[index].text = "x"
			tiles[index].disabled = true
		PlayerRef.PLAYER_2:
			tiles[index].text = "o"
			tiles[index].disabled = true
	
	if check_winner():
		game_over = true
		disable_all_tiles()
		print("Player ", current_player, " wins!")
	elif is_board_full():
		game_over = true
		print("It's a draw!")
	else:
		TurnManager.pass_next()

func check_winner() -> bool:
	if grid_size != 3:
		print("Invalid grid size")  # TODO: Handle this by making winning_combinations dynamic
		return false
	
	var winning_combinations = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8],  # Rows
		[0, 3, 6], [1, 4, 7], [2, 5, 8],  # Columns
		[0, 4, 8], [2, 4, 6]              # Diagonals
	]
	
	for combo in winning_combinations:
		var first_state = tiles[combo[0]].player_owner
		if first_state != PlayerRef.NONE and \
		   first_state == tiles[combo[1]].player_owner and \
		   first_state == tiles[combo[2]].player_owner:
			return true
	
	return false

func is_board_full() -> bool:
	for tile in tiles:
		if tile.player_owner == PlayerRef.NONE:
			return false
	return true

func _on_turn_passed() -> void:
	current_player = PlayerRef.PLAYER_2 if current_player == PlayerRef.PLAYER_1 else PlayerRef.PLAYER_1

func disable_all_tiles():
	for tile in tiles:
		# if tile.player_owner == PlayerRef.NONE:
		tile.disabled = true

func _reset_game():
	super._reset_game()
	
	for tile in tiles:
		tile.reset()
