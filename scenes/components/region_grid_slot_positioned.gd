class_name GridSlotPositionedRegion
extends BaseSlot

var region_index: Vector2i : set=_set_region_index, get=_get_region_index

signal on_clicked(index: Vector2i)


func _ready():
	super._ready()
	pressed.connect(_on_pressed)


func _on_pressed():
	on_clicked.emit(region_index)


func _set_region_index(new_index: Vector2i) -> void:
	region_index = new_index


func _get_region_index() -> Vector2i:
	return region_index
