@abstract class_name BaseSlot
extends Button

const GRID_SLOT_MIN_SIZE = Vector2(64, 64)

var player_owner := GameBase.PlayerRef.NONE : set=_set_player_owner, get=_get_player_owner
var owner_region: BaseRegion : set=set_owner_region, get=get_owner_region
var held_component: BaseComponent : set=place_component, get=get_component


func _ready():
	custom_minimum_size = GRID_SLOT_MIN_SIZE
	_reset_slot()


func _reset_slot():
	_set_player_owner(GameBase.PlayerRef.NONE)
	disabled = false
	text = ""


func _set_player_owner(new_owner: GameBase.PlayerRef) -> void:
	player_owner = new_owner


func _get_player_owner() -> GameBase.PlayerRef:
	return player_owner


func set_owner_region(region: BaseRegion) -> void:
	owner_region = region


func get_owner_region() -> BaseRegion:
	return owner_region


func place_component(component: BaseComponent):
	held_component = component
	add_child(component)  # Adiciona visualmente o Tile como filho do Slot
	# Opcional: centralizar o componente
	# if component is Control:
	component.position = Vector2.ZERO 
	component.anchors_preset = Control.PRESET_FULL_RECT
	
	# IMPORTANTE: Desabilitar o clique do slot?
	disabled = true  # Depende da regra. Geralmente, se tem peça, não clica mais no slot.


func get_component() -> BaseComponent:
	return held_component


@abstract
func _get_region_index()
