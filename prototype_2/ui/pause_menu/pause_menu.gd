class_name PauseMenu, "res://assets/icons/gui/icon_pause_menu.svg"
extends Popup


var _busy: bool = false


onready var _version: Label = $split_container/margin_container/version




func _ready():
	_version.text = "version %s%s" % [ProjectSettings.get("application/config/version"), MainMenu._VERSION_POSTFIX]


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
		SaveHandler.save_game("user://savegame.save")
		
		yield(SaveHandler, "game_save_finished")
		
		_busy = false
		print("Game saved to %s" % "user://savegame.save")


func _load_game():
	if not _busy:
		hide()
		
		SaveHandler.load_game("user://savegame.save")
		
		print("Game loaded from %s" % "user://savegame.save")


func _back_to_main_menu():
	if not _busy:
		get_tree().change_scene_to(load("res://ui/main_menu/main_menu.tscn"))


func _quit_game():
	if not _busy:
		get_tree().quit()
