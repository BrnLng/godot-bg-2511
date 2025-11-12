class_name TileComponent
extends BaseComponent

var is_double_sided : bool = false

enum EdgeType { GRASS, ROAD, CITY, RIVER }
enum Rotation { ROT_0, ROT_90 = 90, ROT_180 = 180, ROT_270 = 270 }
enum RotationAlias { ROT_DEFAULT, ROT_LEFT = 90, ROT_DOWN = 180, ROT_RIGHT = 270 }

@export var north_edge: EdgeType
@export var east_edge: EdgeType  
@export var south_edge: EdgeType
@export var west_edge: EdgeType
@export var tile_id: String
@export var has_monastery: bool = false
@export var road_connections: Array[Vector2] = [] # Conecta bordas que têm estradas
@export var city_connections: Array[Vector2] = [] # Conecta bordas que têm cidades

var current_rotation: Rotation = Rotation.ROT_0
