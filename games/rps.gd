extends Node2D

# Enum to represent the three possible choices in the game.
# This makes the code more readable and less prone to errors.
enum Choice { ROCK, PAPER, SCISSORS }

# Variables to keep track of the scores.
var player_score: int = 0
var computer_score: int = 0

# --- UI Node References ---
@onready var result_label: Label = %ResultLabel
@onready var player_score_label: Label = %PlayerScoreLabel
@onready var computer_score_label: Label = %ComputerScoreLabel
@onready var rock_button: Button = %RockButton
@onready var paper_button: Button = %PaperButton
@onready var scissors_button: Button = %ScissorsButton
@onready var reset_button: Button = %ResetButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the 'pressed' signal of each button to a function.
	# This will call the function when the button is clicked.
	rock_button.pressed.connect(func(): _on_player_choice(Choice.ROCK))
	paper_button.pressed.connect(func(): _on_player_choice(Choice.PAPER))
	scissors_button.pressed.connect(func(): _on_player_choice(Choice.SCISSORS))
	reset_button.pressed.connect(_on_reset_button_pressed)
	
	# Initialize the UI with default values.
	_update_score_ui()
	result_label.text = "Choose your card to start!"


# This function is called when the player clicks one of the choice buttons.
func _on_player_choice(player_choice: Choice) -> void:
	# The computer makes a random choice.
	var computer_choice: Choice = _get_computer_choice()
	
	# Determine the winner of the round.
	var result: String = _determine_winner(player_choice, computer_choice)
	
	# Update the UI to show the result and the new scores.
	result_label.text = "You chose %s. Computer chose %s. %s" % [Choice.keys()[player_choice], Choice.keys()[computer_choice], result]
	_update_score_ui()


# Generates a random choice for the computer.
func _get_computer_choice() -> Choice:
	# Create an array of all possible choices.
	var choices: Array = [Choice.ROCK, Choice.PAPER, Choice.SCISSORS]
	# Pick a random element from the array.
	return choices[randi() % choices.size()]


# Compares the player's and computer's choices to determine the winner.
func _determine_winner(player: Choice, computer: Choice) -> String:
	if player == computer:
		return "It's a Tie!"
	# Winning conditions for the player.
	elif (player == Choice.ROCK and computer == Choice.SCISSORS) or \
		 (player == Choice.PAPER and computer == Choice.ROCK) or \
		 (player == Choice.SCISSORS and computer == Choice.PAPER):
		player_score += 1
		return "You Win!"
	# If the player didn't win, the computer must have.
	else:
		computer_score += 1
		return "Computer Wins!"


# Updates the score labels on the screen.
func _update_score_ui() -> void:
	player_score_label.text = "Player: %d" % player_score
	computer_score_label.text = "Computer: %d" % computer_score


# This function is called when the reset button is pressed.
func _on_reset_button_pressed() -> void:
	# Reset scores to zero.
	player_score = 0
	computer_score = 0
	
	# Update the UI to reflect the reset scores.
	_update_score_ui()
	result_label.text = "New game! Choose your card."
