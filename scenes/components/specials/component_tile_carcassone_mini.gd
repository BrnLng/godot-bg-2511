class_name MiniCarcassoneTileComponent
extends BaseComponent  # GridSlotPositionedRegion

var is_double_sided : bool = false

enum EdgeType { GRASS, ROAD, CITY, RIVER }
enum Extra { NONE, SHIELD, MONASTERY }

var is_active: bool = false

@export var tile_id: String
@export var edges: Array[EdgeType] = [
	EdgeType.GRASS,  # north
	EdgeType.GRASS,  # east
	EdgeType.GRASS,  # south
	EdgeType.GRASS,  # west
] # @export north_edge: EdgeType, east_, south_, west_
@export var has_extra: Extra = Extra.NONE
# @export var road_connections: Array[Vector2] = []  # Conecta bordas que têm estradas
# @export var city_connections: Array[Vector2] = []  # Conecta bordas que têm cidades

# var current_rotation: Rotation = RotationDir.ROT_TOP

func _input(event):
	if event.is_action_pressed("ui_accept") and is_active:  # and tile_in_hand: # Tecla 'R' / ui_rotate -> Enter
		pivot_offset = Vector2(32, 32)
		rotate(RotationDirection.ROT_LEFT)
		# rotation_degrees = 270
		# tile_in_hand.rotate_clockwise() # Você precisará implementar isso no componente
