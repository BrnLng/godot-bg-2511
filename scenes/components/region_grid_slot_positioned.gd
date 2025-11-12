class_name GridSlotRegion
extends BaseSlot


var region_index: Vector2 = Vector2.ZERO : set=_set_region_index, get=_get_region_index

signal on_clicked(index: Vector2)


func _ready():
	super._ready()
	pressed.connect(_on_pressed)


func _on_pressed():
	on_clicked.emit(region_index)


func _set_region_index(new_index: Vector2) -> void:
	region_index = new_index

func _get_region_index() -> Vector2:
	return region_index
