class_name PauseMenu, "res://assets/icons/gui/icon_pause_menu.svg"
extends Popup


const _BACK_TO_MENU_QUESTION: String = "Go Back To The Main Menu?"
const _QUIT_GAME_QUESTION: String = "Quit The Game?"


var _busy: bool = false


onready var _background: ColorRect = $Background
onready var _menu: CenterContainer = $SplitContainer/Menu
onready var _version: Label = $SplitContainer/MarginContainer/Version

onready var _tween: Tween = $Tween




func _ready() -> void:
	_version.text = MainMenu.get_version()


func _unhandled_input(event: InputEvent) -> void:
	if not _busy and event.is_action_released("pause_game"):
		get_tree().set_input_as_handled()
		
		if get_tree().paused:
			_unpause_game()
		else:
			_pause_game()




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
		SaveHandler.save_game(SaveHandler.SAVE_LOCATION)
		
		yield(SaveHandler, "game_save_finished")
		
		_busy = false
		print("Game saved to %s" % SaveHandler.SAVE_LOCATION)


func _load_game() -> void:
	if not _busy:
		hide()
		
		SaveHandler.load_game(SaveHandler.SAVE_LOCATION)
		
		print("Game loaded from %s" % SaveHandler.SAVE_LOCATION)


func _back_to_main_menu() -> void:
	if not _busy:
		var dialog: ConfirmationDialog = ConfirmationDialog.new()
		
		dialog.dialog_text = _BACK_TO_MENU_QUESTION
		dialog.window_title = ""
		
		dialog.get_cancel().connect("pressed", dialog, "queue_free")
		dialog.connect("confirmed", get_tree(), "change_scene_to", [SaveHandler.MenuScene])
		
		_menu.add_child(dialog)
		dialog.popup_centered()


func _quit_game() -> void:
	if not _busy:
		var dialog: ConfirmationDialog = ConfirmationDialog.new()
		
		dialog.dialog_text = _QUIT_GAME_QUESTION
		dialog.window_title = ""
		
		dialog.get_cancel().connect("pressed", dialog, "queue_free")
		dialog.connect("confirmed", get_tree(), "quit")
		
		_menu.add_child(dialog)
		dialog.popup_centered()
