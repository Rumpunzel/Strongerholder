class_name GUI, "res://class_icons/gui/icon_gui.svg"
extends Control


signal new_game
signal load_game
signal game_load_finished
signal quit_game


onready var _main_menu = $MainMenu
onready var _loading_gui: LoadingGUI = $LoadingGUI
onready var _pause_menu = $PauseMenu
onready var _game_gui = $GameGUI




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func show_main_menu() -> void:
	_main_menu.show()

func loading_game(new_game: bool = false) -> void:
	_loading_gui.loading_game(new_game)



func _start_new_game() -> void:
	emit_signal("new_game")


func _load_game() -> void:
	emit_signal("load_game")

func _input_after_load() -> void:
	emit_signal("game_load_finished")


func _quit_game() -> void:
	emit_signal("quit_game")
