class_name PauseMenu, "res://assets/icons/gui/icon_pause_menu.svg"
extends Popup


const _BACK_TO_MENU_QUESTION: String = "Go Back To The Main Menu?"
const _QUIT_GAME_QUESTION: String = "Quit The Game?"


var _busy: bool = false


onready var _menu: CenterContainer = $split_container/menu
onready var _version: Label = $split_container/margin_container/version




func _ready():
	_version.text = MainMenu.get_version()


func _process(_delta: float):
	if not _busy and Input.is_action_just_pressed("pause_game"):
		if get_tree().paused:
			_unpause_game()
		else:
			_pause_game()




func _pause_game():
	get_tree().paused = true
	
	show()

func _unpause_game():
	get_tree().paused = false
	
	hide()


func _save_game():
	if not _busy:
		_busy = true
		SaveHandler.save_game(SaveHandler.SAVE_LOCATION)
		
		yield(SaveHandler, "game_save_finished")
		
		_busy = false
		print("Game saved to %s" % SaveHandler.SAVE_LOCATION)


func _load_game():
	if not _busy:
		hide()
		
		SaveHandler.load_game(SaveHandler.SAVE_LOCATION)
		
		print("Game loaded from %s" % SaveHandler.SAVE_LOCATION)


func _back_to_main_menu():
	if not _busy:
		var dialog: ConfirmationDialog = ConfirmationDialog.new()
		
		dialog.dialog_text = _BACK_TO_MENU_QUESTION
		dialog.window_title = ""
		
		dialog.get_cancel().connect("pressed", dialog, "queue_free")
		dialog.connect("confirmed", get_tree(), "change_scene_to", [SaveHandler.MENU_SCENE])
		
		_menu.add_child(dialog)
		dialog.popup_centered()


func _quit_game():
	if not _busy:
		var dialog: ConfirmationDialog = ConfirmationDialog.new()
		
		dialog.dialog_text = _QUIT_GAME_QUESTION
		dialog.window_title = ""
		
		dialog.get_cancel().connect("pressed", dialog, "queue_free")
		dialog.connect("confirmed", get_tree(), "quit")
		
		_menu.add_child(dialog)
		dialog.popup_centered()
