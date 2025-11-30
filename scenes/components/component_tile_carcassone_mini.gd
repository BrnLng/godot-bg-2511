class_name MiniCarcassoneTileComponent
extends GridSlotPositionedRegion

var is_double_sided : bool = false

enum EdgeType { GRASS, ROAD, CITY, RIVER }
enum Extra { NONE, SHIELD, MONASTERY }

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
