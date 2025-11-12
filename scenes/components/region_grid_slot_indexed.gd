class_name GridSlotIndexedRegion
extends BaseSlot

var region_index: int = -1 : set=_set_region_index, get=_get_region_index

signal on_clicked(index: int)


func _ready():
	super._ready()
	pressed.connect(_on_pressed)


func _on_pressed():
	on_clicked.emit(region_index)


func _set_region_index(new_index: int) -> void:
	region_index = new_index


func _get_region_index() -> int:
	return region_index
