class_name PauseMenu, "res://class_icons/gui/icon_pause_menu.svg"
extends Menu


const BACK_TO_MENU_QUESTION: String = "Go Back To The Main Menu?"
const QUIT_GAME_QUESTION: String = "Quit The Game?"


var _busy: bool = false

var main_node: Main


onready var _background: ColorRect = $Background
onready var _menu: CenterContainer = $SplitContainer/Menu
onready var _version: Label = $MarginContainer/Version

onready var _tween: Tween = $Tween




func _ready() -> void:
	_version.text = Main.get_version()


func _unhandled_input(event: InputEvent) -> void:
	if _listening_to_inputs() and event.is_action_released("pause_game"):
		get_tree().set_input_as_handled()
		
		if get_tree().paused:
			_unpause_game()
		else:
			_pause_game()




func _listening_to_inputs() -> bool:
	if not main_node:
		return false
	
	return not _busy and main_node.is_in_game()


func _pause_game() -> void:
	get_tree().paused = true
	
	show()
	
	_tween.interpolate_property(_background, "color:a", 0.0, 200.0 / 256.0, 0.1, Tween.TRANS_LINEAR)
	_tween.start()


func _unpause_game() -> void:
	_tween.interpolate_property(_background, "color:a", 200.0 / 256.0, 0.0, 0.1, Tween.TRANS_LINEAR)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	get_tree().paused = false
	
	hide()



func _save_game() -> void:
	if not _busy:
		_busy = true
		main_node.save_game()
		
		yield(main_node, "game_save_finished")
		
		_busy = false


func _load_game() -> void:
	if not _busy:
		hide()
		
		main_node.load_game()


func _back_to_main_menu() -> void:
	if not _busy:
		var dialog: ConfirmationDialog = ConfirmationDialog.new()
		
		dialog.dialog_text = BACK_TO_MENU_QUESTION
		dialog.window_title = ""
		
		dialog.get_cancel().connect("pressed", dialog, "queue_free")
		dialog.connect("confirmed", self, "_open_main_menu")
		
		_menu.add_child(dialog)
		dialog.popup_centered()

func _open_main_menu() -> void:
	hide()
	main_node.open_main_menu()


func _quit_game() -> void:
	if not _busy:
		var dialog: ConfirmationDialog = ConfirmationDialog.new()
		
		dialog.dialog_text = QUIT_GAME_QUESTION
		dialog.window_title = ""
		
		dialog.get_cancel().connect("pressed", dialog, "queue_free")
		dialog.connect("confirmed", get_tree(), "quit")
		
		_menu.add_child(dialog)
		dialog.popup_centered()
