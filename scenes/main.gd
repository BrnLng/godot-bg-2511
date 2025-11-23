extends  Node2D

@onready var label_left: Label = %LabelLeft
@onready var mid_panel: Control = %MidPanel
@onready var label_right: RichTextLabel = %LabelRight
# @onready var history_scroll: ScrollContainer = label_right.get_parent() as ScrollContainer

var history_counter: int = 1

var _game: GameBase


func _ready() -> void:
	_game = $GamePlug.get_children()[0] as GameBase
	if not _game:
		print_debug("Error: game connect error @ main")
	for i in range($GamePlug.get_children().size()-1):
		$GamePlug.get_children()[i+1].queue_free()
	

	_game._hud_message.connect(_on_hud_message_update)
	_game._hud_history.connect(_on_hud_history_update)
	_game._hud_panel.connect(_on_hud_panel_update)


func _on_hud_message_update(msg:String) -> void:
	label_left.text = msg


func _on_hud_history_update(msg:String) -> void:
	label_right.text = "[color=DIM_GRAY]" + ("%03d" % history_counter) + ".[/color] " + msg + "  \n" + label_right.text
	history_counter += 1
	# The scrollbar's max_value is not updated in the same frame the label's text is changed.
	# We need to wait for the next idle frame for the container to resize and update the scrollbar.
	# call_deferred("_scroll_history_to_bottom")
	#label_right.scroll_to_line(history_counter)


# func _scroll_history_to_bottom() -> void:
# 	history_scroll.scroll_vertical = int(history_scroll.get_v_scroll_bar().max_value)


func _on_hud_panel_update(item:Node) -> void:
	Utils.remove_all_children(mid_panel)
	mid_panel.add_child(item)
