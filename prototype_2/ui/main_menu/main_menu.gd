class_name MainMenu
extends CenterContainer



func _new_game():
	get_tree().paused = true
	
	var load_process = get_tree().change_scene_to(load("res://test.tscn"))
	
	if load_process == OK:
		SaveHandler.starting_new_game()
	else:
		assert(false)


func _load_game():
	get_tree().paused = true
	
	var load_process = get_tree().change_scene_to(load("res://test.tscn"))
	
	if load_process == OK:
		SaveHandler.load_game("user://savegame.save")
		
		print("Game loaded from %s" % "user://savegame.save")
	else:
		assert(false)


func _quit_game():
	get_tree().quit()
