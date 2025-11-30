extends CanvasLayer

@onready var label_left: Label = %LabelLeft
@onready var mid_panel: Control = %MidPanel
@onready var label_right: RichTextLabel = %LabelRight


func on_hud_message_update(msg:String) -> void:
	label_left.text = msg


func on_hud_history_update(msg:String) -> void:
	# TODO: pending optimization: using append_text to prepend, to not parse all bbcode every change
	# label_right.append_text("[color=DIM_GRAY]" + TurnManager.in_turn_counter + ".[/color] " + msg + "  \n")  # last space before \n is for getting out of scrollbar
	label_right.text = "[color=DIM_GRAY]" + TurnManager.in_turn_counter + ".[/color] " + msg + \
		"  \n" + label_right.text  # last space before \n is for getting out of scrollbar
	# label_right.text = "[color=DIM_GRAY]" + ("%03d" % history_counter) + ".[/color] " + msg + "  \n" + label_right.text


func on_hud_panel_update(item:Node) -> void:
	Utils.remove_all_children(mid_panel)
	mid_panel.add_child(item)
	print("added item to panel: " + str(item))
