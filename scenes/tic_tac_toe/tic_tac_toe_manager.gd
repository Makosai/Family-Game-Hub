extends Node

@onready var res_game = preload("res://scenes/tic_tac_toe/game.tscn")

var super_mode = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_super_mode()

func toggle_super_mode():
	if !super_mode:
		$Game.queue_free() # Clear the first board

		var game_i = 1

		for x in range(3):
			for y in range(3):
				var game = res_game.instantiate()
				game.set_name(str(game_i))
				game.position.x = 1500 * x
				game.position.y = 1500 * y
				game_i += 1
				add_child(game)

		# var ttt = get_node("4")
		# ttt.call("win_checkster")
	else:
		for game in get_children():
			game.queue_free()

		var solo_game = res_game.instantiate()
		solo_game.set_name("Game")
		add_child(solo_game)
	super_mode = !super_mode
