class_name GridSlotIndexedRegion
extends BaseSlot

var region_index: int = -1
var is_double_sided : bool = false

signal on_clicked(index: int)


func _ready():
	super._ready()
	pressed.connect(_on_pressed)


func _on_pressed():
	on_clicked.emit(region_index)
