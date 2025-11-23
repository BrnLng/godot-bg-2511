extends Node

func remove_all_children(parent_node):
	for child in parent_node.get_children():
		child.queue_free()
