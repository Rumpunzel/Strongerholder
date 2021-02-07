class_name GUI, "res://class_icons/gui/icon_gui.svg"
extends Control


signal new_game
signal load_game
signal game_load_finished
signal quit_game


var main_node: Main setget set_main_node


onready var _game_gui: GameGUI = $GameGUI
onready var _main_menu: MainMenu = $MainMenu
onready var _pause_menu: PauseMenu = $PauseMenu
onready var _loading_gui: LoadingGUI = $LoadingGUI




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func show_main_menu() -> void:
	_main_menu.show()

func loading_game(new_game: bool = false) -> void:
	_loading_gui.loading_game(new_game)



func set_main_node(new_main_node) -> void:
	main_node = new_main_node
	_pause_menu.main_node = main_node



func _on_object_selected(new_node: GameObject) -> void:
	_game_gui.object_selected(new_node)


func _start_new_game() -> void:
	emit_signal("new_game")


func _load_game() -> void:
	emit_signal("load_game")

func _input_after_load() -> void:
	emit_signal("game_load_finished")


func _quit_game() -> void:
	emit_signal("quit_game")
