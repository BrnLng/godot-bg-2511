extends GameBase

@export var tile_type: PackedScene

@onready var grid_container = %MainGridContainer
var tiles: Dictionary[Vector2i, GridSlotPositionedRegion] = {}

const TILE_SIZE = Vector2(64, 64)

func _ready():
	super._ready()
	grid_container.position = Vector2(-TILE_SIZE.x/2, -TILE_SIZE.y/2)
	setup_grid()

func setup_grid():
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen_id)
	var grid_size = Vector2(int(screen_size.x / TILE_SIZE.x), int(screen_size.y / TILE_SIZE.y))
	grid_container.columns = grid_size.x

	for j in range(grid_size.y):
		for i in range(grid_size.x):
			if not tile_type:
				push_error("tile_type PackedScene is not set in the inspector!")
				return
			
			var tile_instance = tile_type.instantiate()
			var tile = tile_instance as GridSlotPositionedRegion
			if not tile:
				push_error("The root node of the tile_type scene must extend GridSlotPositionedRegion.")
				tile_instance.queue_free() # Clean up the instance that we can't use
				continue
			
			var index = Vector2i(i, j)
			# tile.position = Vector2(i * TILE_SIZE.x, j * TILE_SIZE.y)  # autotiled because Control
			tile.region_index = index
			tile.on_clicked.connect(_on_tile_clicked)
			tile.text = str(index)
			tiles[index] = tile
			grid_container.add_child(tile)

func _on_tile_clicked(index: Vector2i):
	if is_game_over or tiles[index].player_owner != PlayerRef.NONE \
		or index not in tiles.keys():  # or not index BUGS @ 0,0
		print("Invalid move")
		return
	
	tiles[index].player_owner = current_player
	match tiles[index].player_owner:
		PlayerRef.PLAYER_1:
			#tiles[index].text = "x"
			tiles[index].pivot_offset = Vector2(32, 32)
			tiles[index].rotation_degrees = 270
			tiles[index].disabled = true
		PlayerRef.PLAYER_2:
			#tiles[index].text = "o"
			tiles[index].pivot_offset = Vector2(32, 32)
			tiles[index].rotation_degrees = 90
			tiles[index].disabled = true
	
	if check_winner():
		is_game_over = true
		disable_all_tiles()
		print("Player ", current_player, " wins!")
	elif is_board_full():
		is_game_over = true
		print("It's a draw!")
	else:
		TurnManager.pass_next()

func check_winner() -> bool:
	return false

func is_board_full() -> bool:
	for tile_index in tiles.keys():
		if tiles[tile_index].player_owner == PlayerRef.NONE:
			return false
	return true

func _on_turn_passed() -> void:
	current_player = PlayerRef.PLAYER_2 if current_player == PlayerRef.PLAYER_1 else PlayerRef.PLAYER_1

func disable_all_tiles():
	for tile_index in tiles.keys():
		# if tile.player_owner == PlayerRef.NONE:
		tiles[tile_index].disabled = true

func _reset_game():
	super._reset_game()
	
	for tile_index in tiles.keys():
		tiles[tile_index]._reset_slot()
