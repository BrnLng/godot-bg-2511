extends GameBase

enum Choice { ROCK, PAPER, SCISSORS }

@onready var rock_button: Button = %RockButton
@onready var paper_button: Button = %PaperButton
@onready var scissors_button: Button = %ScissorsButton
@onready var reset_button: Button = %ResetButton


func _ready() -> void:
	rock_button.pressed.connect(func(): _on_player_choice(Choice.ROCK))
	paper_button.pressed.connect(func(): _on_player_choice(Choice.PAPER))
	scissors_button.pressed.connect(func(): _on_player_choice(Choice.SCISSORS))
	reset_button.pressed.connect(_on_reset_button_pressed)

	var buttons_parent = rock_button.get_parent()  # any button would work
	buttons_parent.get_parent().remove_child(buttons_parent)
	call_deferred("to_panel_item", buttons_parent)
	call_deferred("show_message", "Pick your choice to start!")


# This function is called when the player clicks one of the choice buttons.
func _on_player_choice(player_choice: Choice) -> void:
	var computer_choice: Choice = _get_computer_choice(true)
	var result: String = _determine_winner(player_choice, computer_choice)
	show_message("You chose %s. Computer chose %s. %s" % \
		[Choice.keys()[player_choice], Choice.keys()[computer_choice], result])
	_update_score_history()


func _get_computer_choice(is_dumb=false) -> Choice:
	if is_dumb:
		return Choice.ROCK
	var choices: Array = [Choice.ROCK, Choice.PAPER, Choice.SCISSORS]
	return choices[randi() % choices.size()]


func _determine_winner(a_choice: Choice, b_choice: Choice) -> String:
	if a_choice == b_choice:
		return "It's a Tie!"
	elif (a_choice == Choice.ROCK and b_choice == Choice.SCISSORS) or \
		 (a_choice == Choice.PAPER and b_choice == Choice.ROCK) or \
		 (a_choice == Choice.SCISSORS and b_choice == Choice.PAPER):
		add_score(PlayerRef.PLAYER_1)
		return "You Win!"
	else:
		add_score(PlayerRef.PLAYER_2)
		return "Computer Wins!"


# Updates the score labels on the screen.
func _update_score_history() -> void:
	var best_of = get_game_round_best_of(get_score(PlayerRef.PLAYER_1), get_score(PlayerRef.PLAYER_2))
	add_history("Player: [color=#33F]%d[/color] x Computer: [color=#C33]%d[/color]
	in [color=#669]%s[/color]" % [get_score(PlayerRef.PLAYER_1), get_score(PlayerRef.PLAYER_2), best_of])


# This function is called when the reset button is pressed.
func _on_reset_button_pressed() -> void:
	reset_game()
	pass_turn()
	show_message("New game! Pick your choice.")
	_update_score_history()
