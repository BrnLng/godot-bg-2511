extends GameBase

enum Choice { ROCK, PAPER, SCISSORS }

@onready var rock_button: Button = %RockButton
@onready var paper_button: Button = %PaperButton
@onready var scissors_button: Button = %ScissorsButton
@onready var reset_button: Button = %ResetButton

var player_score: int = 0
var computer_score: int = 0


func _ready() -> void:
	rock_button.pressed.connect(func(): _on_player_choice(Choice.ROCK))
	paper_button.pressed.connect(func(): _on_player_choice(Choice.PAPER))
	scissors_button.pressed.connect(func(): _on_player_choice(Choice.SCISSORS))
	reset_button.pressed.connect(_on_reset_button_pressed)

	var buttons_parent = rock_button.get_parent()
	buttons_parent.get_parent().remove_child(buttons_parent)
	call_deferred("hud_panel_show", buttons_parent)
	#hud_panel_show(buttons_parent)
	
	# Initialize the UI with default values.
	# call_deferred("_update_score_ui")
	call_deferred("hud_message", "Choose your card to start!")


# This function is called when the player clicks one of the choice buttons.
func _on_player_choice(player_choice: Choice) -> void:
	# The computer makes a random choice.
	var computer_choice: Choice = _get_computer_choice()
	
	# Determine the winner of the round.
	var result: String = _determine_winner(player_choice, computer_choice)
	
	# Update the UI to show the result and the new scores.
	hud_message("You chose %s. Computer chose %s. %s" % [Choice.keys()[player_choice], Choice.keys()[computer_choice], result])
	_update_score_ui()


# Generates a random choice for the computer.
func _get_computer_choice() -> Choice:
	# Create an array of all possible choices.
	var choices: Array = [Choice.ROCK, Choice.PAPER, Choice.SCISSORS]
	# Pick a random element from the array.
	return choices[randi() % choices.size()]


# Compares the player's and computer's choices to determine the winner.
func _determine_winner(player_choice: Choice, computer_choice: Choice) -> String:
	if player_choice == computer_choice:
		return "It's a Tie!"
	# Winning conditions for the player.
	elif (player_choice == Choice.ROCK and computer_choice == Choice.SCISSORS) or \
		 (player_choice == Choice.PAPER and computer_choice == Choice.ROCK) or \
		 (player_choice == Choice.SCISSORS and computer_choice == Choice.PAPER):
		player_score += 1
		return "You Win!"
	# If the player didn't win, the computer must have.
	else:
		computer_score += 1
		return "Computer Wins!"


# Updates the score labels on the screen.
func _update_score_ui() -> void:
	var game_round = get_game_round_best_of(player_score, computer_score)
	hud_history("Player: [color=#33F]%d[/color] x Computer: [color=#C33]%d[/color]\nin [color=#669]%s[/color]" % [player_score, computer_score, game_round])
	# player_score_label.text = "Player: %d" % player_score
	# computer_score_label.text = "Computer: %d" % computer_score


# This function is called when the reset button is pressed.
func _on_reset_button_pressed() -> void:
	# Reset scores to zero.
	player_score = 0
	computer_score = 0
	
	# Update the UI to reflect the reset scores.
	_update_score_ui()
	hud_message("New game! Pick your choice.")
