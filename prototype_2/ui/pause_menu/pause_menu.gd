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
	var nodes_to_save: Array = get_tree().get_nodes_in_group(GameObject.PERSISTENT)
	
	for node in nodes_to_save:
		pass


func _quit_game():
	get_tree().quit()
