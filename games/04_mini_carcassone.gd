extends GameBase

# @export var tile_cell_type: BaseRegion
@export var game_tile_type: PackedScene

@onready var grid_container = %MainGridContainer
var cells: Dictionary[Vector2i, GridSlotPositionedRegion] = {}

const TILE_SIZE = Vector2(64, 64)


func _ready():
	super._ready()
	grid_container.position = Vector2(-TILE_SIZE.x/2, -TILE_SIZE.y/2)
	setup_grid()

	var first_tile: MiniCarcassoneTileComponent = game_tile_type.instantiate() as MiniCarcassoneTileComponent
	first_tile.text = "test"
	first_tile.is_active = true
	call_deferred("to_panel_item", first_tile)


func setup_grid():
	if not game_tile_type:
		push_error("tile_type PackedScene is not set in the inspector!")
		return
	
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen_id)
	var grid_size = Vector2(int(screen_size.x / TILE_SIZE.x), int(screen_size.y / TILE_SIZE.y))
	grid_container.columns = grid_size.x

	for j in range(grid_size.y):
		for i in range(grid_size.x):		
			# var tile_instance = tile_cell_type.new()  # tile_type.instantiate()
			# var tile_cell = tile_instance as GridSlotPositionedRegion
			var tile_cell = GridSlotPositionedRegion.new()
			# if not tile_cell:
			# 	push_error("The root node of the tile_type scene must extend GridSlotPositionedRegion.")
			# 	tile_instance.queue_free()  # Clean up the instance that we can't use
			# 	continue
			
			var index = Vector2i(i, j)
			# TODO if needed: tile.position = Vector2(i * TILE_SIZE.x, j * TILE_SIZE.y)  # autotiled because Control
			tile_cell.region_index = index
			tile_cell.on_clicked.connect(_on_cell_clicked)
			tile_cell.text = str(index)
			cells[index] = tile_cell
			grid_container.add_child(tile_cell)


func _on_cell_clicked(index: Vector2i):
	if is_game_over or cells[index].player_owner != PlayerRef.NONE \
		or index not in cells.keys():  # or not index BUGS @ 0,0
		print("Invalid move")
		return
	
	cells[index].player_owner = current_player
	cells[index].place_component(get_panel_item())
	# match cells[index].player_owner:
	# 	PlayerRef.PLAYER_1:
	# 		#tiles[index].text = "x"
	# 		cells[index].pivot_offset = Vector2(32, 32)
	# 		cells[index].rotation_degrees = 270
	# 		cells[index].disabled = true
	# 	PlayerRef.PLAYER_2:
	# 		#tiles[index].text = "o"
	# 		cells[index].pivot_offset = Vector2(32, 32)
	# 		cells[index].rotation_degrees = 90
	# 		cells[index].disabled = true
	
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
	for tile_index in cells.keys():
		if cells[tile_index].player_owner == PlayerRef.NONE:
			return false
	return true


func disable_all_tiles():
	for tile_index in cells.keys():
		# if tile.player_owner == PlayerRef.NONE:
		cells[tile_index].disabled = true


func reset_game():
	super.reset_game()
	
	for tile_index in cells.keys():
		cells[tile_index]._reset_slot()
