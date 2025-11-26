extends CanvasLayer

@onready var label_left: Label = %LabelLeft
@onready var mid_panel: Control = %MidPanel
@onready var label_right: RichTextLabel = %LabelRight
# @onready var history_scroll: ScrollContainer = label_right.get_parent() as ScrollContainer


func _on_hud_message_update(msg:String) -> void:
	label_left.text = msg


func _on_hud_history_update(msg:String) -> void:
	label_right.text = "[color=DIM_GRAY]" + TurnManager.in_turn_counter + ".[/color] " + msg + "  \n" + label_right.text
	# label_right.text = "[color=DIM_GRAY]" + ("%03d" % history_counter) + ".[/color] " + msg + "  \n" + label_right.text
	# history_counter += 1
	# The scrollbar's max_value is not updated in the same frame the label's text is changed.
	# We need to wait for the next idle frame for the container to resize and update the scrollbar.
	# call_deferred("_scroll_history_to_bottom")
	#label_right.scroll_to_line(history_counter)


# func _scroll_history_to_bottom() -> void:
# 	history_scroll.scroll_vertical = int(history_scroll.get_v_scroll_bar().max_value)


func _on_hud_panel_update(item:Node) -> void:
	Utils.remove_all_children(mid_panel)
	mid_panel.add_child(item)
	print("added item to panel: " + str(item))
