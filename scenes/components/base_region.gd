class_name BaseRegion
extends GridContainer

var grid_size_i: Vector2i = Vector2i.ZERO
var slots: Array[BaseSlot] = []


func append_slot(new_slot: BaseSlot) -> void:
	if new_slot in slots:
		print(new_slot.name + " slot already at region " + name)
	else:
		slots.append(new_slot)


func remove_slots(slots_to_remove: Array[BaseSlot]) -> void:
	for slot in slots_to_remove:
		slots.erase(slot)
		# slots.remove_at(0)


func remove_slot(slot_to_remove: BaseSlot) -> void:
	remove_slots([slot_to_remove])
