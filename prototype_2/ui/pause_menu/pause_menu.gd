class_name PauseMenu, "res://assets/icons/gui/icon_pause_menu.svg"
extends Popup




func _process(_delta: float):
	if Input.is_action_just_pressed("pause_game"):
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
	SaveHandler.save_game("user://savegame.save")
	
	yield(SaveHandler, "game_save_finished")
	
	print("Game saved to %s" % "user://savegame.save")


func _load_game():
	SaveHandler.load_game("user://savegame.save")
	
	yield(SaveHandler, "game_load_finished")
	
	print("Game loaded from %s" % "user://savegame.save")


func _quit_game():
	get_tree().quit()
