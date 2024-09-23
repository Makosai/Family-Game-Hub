extends Node

signal piece_placed2(num: int)

@onready var control = get_node("../Control")
@onready var win_msg = get_node("../Control/WinMsg")
@onready var super_toggle = get_node("../Control/SuperToggle") as BaseButton
@onready var res_game = preload("res://scenes/tic_tac_toe/game.tscn")

var super_mode = true
var score_x = 0
var score_o = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_msg.visible = false
	super_toggle.pressed.connect(toggle_super_mode.bind())

	toggle_super_mode()

func toggle_super_mode():
	win_msg.visible = false
	TweenUtils.tween_position(self, control, Vector2(0, 0))

	if !super_mode:
		for game in get_children():
			Utils.queue_free_name(game) # Clear the first board

		for x in range(3):
			for y in range(3):
				var game = res_game.instantiate()
				game.set_name(str(TicTacToe.xy_to_num(x, y)))
				game.position.x = 375 * (x - 1)
				game.position.y = 375 * (y - 1)
				add_child(game)

				game.call("activate_super_mode")

		# var ttt = get_node("4")
		# ttt.call("win_checkster")
	else:
		for game in get_children():
			Utils.queue_free_name(game)

		var solo_game = res_game.instantiate()
		solo_game.set_name("Game")
		add_child(solo_game)
	super_mode = !super_mode

func win_checkster(winner: int):
	var win_types = [
		[1,2,3], [4,5,6], [7,8,9],
		[1,4,7], [2,5,8], [3,6,9],
		[1,5,9], [3,5,7]
	]

	for win in win_types:
		var in_a_rows = 3 # how many in a row the player has
		for num in win:
			var node = get_node(str(num))
			if node != null && node.has_meta("winner") && node.get_meta("winner") == winner:
				in_a_rows -= 1
			else:
				break

			if(in_a_rows == 0):
				return true
	return false

func piece_placed(num: int, next_player: int):
	if win_checkster(0 if next_player == 1 else 1):
		if next_player == 0:
			score_o += 1
		else:
			score_x += 1

		win_msg.visible = true
		var is_x = true if (0 if next_player == 1 else 1) == TicTacToe.PLAYERS.X else false
		var color = TicTacToe.X_RED if is_x else TicTacToe.O_BLUE
		var player = "X" if is_x else "O"

		win_msg.text = "[center]Player [i][color=" + color + "]" + player + "[/color][/i] wins![/center]"

		print("X" if next_player == 1 else "O" + " has won!")

		# Fade out the last played board
		# Set all boards to waiting
		# if waiting and in super, the next_player should be -1
		# then call reset() on all boards
		return

	const valid_pieces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
	const faded_alpha = 0.4
	const shown_alpha = 1.0

	var next_game = get_node(str(num))
	var free_space = false # If the next player can play anywhere because of a won space
	if next_game != null && next_game.game_status == TicTacToe.STATUS.ENDED:
		free_space = true

		var game = get_node("5") # center
		if game != null:
			TweenUtils.tween_position(self, control, game.position)

	for game in get_children():
		if free_space:
			if game.game_status == TicTacToe.STATUS.ENDED:
				TweenUtils.tween_modulate_a(self, game, faded_alpha)
				continue
			game.game_status = TicTacToe.STATUS.STARTED
			game.current_player = next_player
			TweenUtils.tween_modulate_a(self, game, shown_alpha)
		elif game.name == str(num):
			game.game_status = TicTacToe.STATUS.STARTED
			game.current_player = next_player
			TweenUtils.tween_position(self, control, game.position)
			TweenUtils.tween_modulate_a(self, game, shown_alpha)
		elif valid_pieces.has(game.name):
			if game.game_status == TicTacToe.STATUS.ENDED:
				TweenUtils.tween_modulate_a(self, game, faded_alpha)
				continue
			game.game_status = TicTacToe.STATUS.HALTED
			TweenUtils.tween_modulate_a(self, game, faded_alpha)
