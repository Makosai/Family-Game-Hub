class_name TicTacToe extends Node

# NOTE: For super tic-tac-toe, have an "eye" button in the top right that centers
# the board and then a horizontal slider that allows the user to zoom in and out.

# Each turn will focus on the proper tile and the user can zoom out whenever.
# For UX, the Status should change to "Player X is plotting..."

# For fun, all Statuses should eventually have random variations.

# var super_mode = true, set by a parent
# Game 1, 2, 3, 4, 5, 6, 7, 8, 9
# only set STATUS.WAITING if super_mode is false.
# Then make a reset() func that the SuperTicTacToe script can call.
# The xy_to_num the player clicks is just the xy_to_num Game_NUM that is played next (unless it's won, then the player is in free-mode).
# STATUS.READY to STATUS.PAUSED is required to prevent bleeding into other games. This stops inputs. Unless the player is in free-mode.
# In which case, all boards should be swapped from STATUS.PAUSED to .READY except the .ENDED ones.
# When a new board comes into play, override the current_player in that board to match super's.

### Resources ###
@onready var status = get_node("../../Status")
@onready var win_msg = get_node("../../WinMsg")
@onready var pieces = $Board/Pieces
@onready var selectors = $Board/Selectors
const res_tic_tac_toe = "res://assets/tic_tac_toe/"
const res_board = res_tic_tac_toe + "board/"
const res_pieces = res_tic_tac_toe + "pieces/"
@onready var board_selector = preload(res_board + "board_selector.res")
@onready var o_piece = preload(res_pieces + "pieces_o.res")
@onready var x_piece = preload(res_pieces + "pieces_x.res")

### Variables ###
# Game status
var board_setup = false
var game_status: STATUS = STATUS.READY
var current_player: PLAYERS = PLAYERS.X
var score_x = 0
var score_o = 0

# Start position for the top left corner.
const START_X = 272
const START_Y = 258

# How much to move each piece by.
const INCRE_X = 8 * 44
const INCRE_Y = 8 * 46

# Selector Size
const SELECTOR_SIZE = 300

# Colors
const X_RED = "#ff3d3d"
const O_BLUE = "#6969ff"
const B_YELLOW = "#ffef70"

# enums
enum PLAYERS { X, O }
enum STATUS { READY, STARTED, ENDED, WAITING }

### Functions ###
func _ready():
	setup_board()

func xy_to_num(x: int, y: int):
	x += 1; y += 1
	if y == 1: return x
	if y == 2: return x + 3
	if y == 3: return x + 6

func setup_board():
	for x in range(3):
		for y in range(3):
			var new_board_selector: Button = board_selector.instantiate()
			new_board_selector.set_name(str(xy_to_num(x, y)))
			new_board_selector.position.x = START_X + (self.position.x + INCRE_X * x - int(SELECTOR_SIZE / 2.0))
			new_board_selector.position.y = START_Y + (self.position.y + INCRE_Y * y - int(SELECTOR_SIZE / 2.0))

			new_board_selector.pressed.connect(place_piece.bind(x, y))

			selectors.add_child(new_board_selector)

			change_turn()

			board_setup = true

# place_piece(PLAYERS.O, o_piece, x, y)
# place_piece(PLAYERS.X, x_piece, x, y)
func place_piece(x: int, y: int):
	if game_status == STATUS.WAITING:
		win_msg.text = ""
		win_msg.visible = false
		game_status = STATUS.STARTED
		for child in pieces.get_children():
			child.queue_free()

		return

	var x_already = pieces.has_node(str(PLAYERS.X) + "_" + str(xy_to_num(x, y)))
	var o_already = pieces.has_node(str(PLAYERS.O) + "_" + str(xy_to_num(x, y)))

	if x_already or o_already:
		## TODO: Wiggle the piece there.
		# There's a piece here already.
		print(xy_to_num(x, y))
		return

	var piece = x_piece if current_player == PLAYERS.X else o_piece
	var new_piece: Sprite2D = piece.instantiate()
	new_piece.set_name(str(current_player) + "_" + str(xy_to_num(x, y)))
	new_piece.position.x = self.position.x + START_X + (INCRE_X * x)
	new_piece.position.y = self.position.y + START_Y + (INCRE_Y * y)

	pieces.add_child(new_piece)

	# TODO: Check for win-conditions
	var game_end_setup = func():
		game_status = STATUS.ENDED

		win_msg.visible = true

	if win_checkster():
		game_end_setup.call()

		var is_x = true if current_player == PLAYERS.X else false
		var color = X_RED if is_x else O_BLUE
		var player = "X" if is_x else "O"

		win_msg.text = "[center]Player [i][color=" + color + "]" + player + "[/color][/i] wins![/center]"
	else:
		if(pieces.get_child_count() >= 9):
			game_end_setup.call()

			win_msg.text = "[center]It's a [i][color=" + B_YELLOW + "]Draw[/color][/i]![/center]"

	change_turn()

func win_checkster() -> bool:
	print("testtt")
	var win_types = [
		[1,2,3], [4,5,6], [7,8,9],
		[1,4,7], [2,5,8], [3,6,9],
		[1,5,9], [3,5,7]
	]

	for win in win_types:
		var in_a_rows = 3 # how many in a row the player has
		for num in win:
			print("testing")
			if pieces.has_node(str(current_player) + "_" + str(num)):
				in_a_rows -= 1
			else:
				break

			if(in_a_rows == 0):
				return true
	return false

func change_turn():
	if game_status == STATUS.ENDED:
		if current_player == PLAYERS.X:
			score_x += 1
		else:
			score_o += 1
		game_status = STATUS.WAITING

	if board_setup:
		current_player = PLAYERS.X if current_player == PLAYERS.O else PLAYERS.O

	var is_x = true if current_player == PLAYERS.X else false
	var color = X_RED if is_x else O_BLUE
	var player = "X" if is_x else "O"

	status.text = "[center]Ready Player [i][color=" + color + "]" + player + "[/color][/i]![/center]"
