extends Node


signal game_save_started()
signal game_save_finished()
signal game_load_started()
signal game_load_finished()


var _saver_loader: SaverLoader = SaverLoader.new()




func _unhandled_input(event: InputEvent):
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
		if $popup.visible:
			$popup.hide()
			emit_signal("game_load_finished")
			get_tree().paused = false




func save_game(path: String) -> void:
	var save_file := File.new()
	
	save_file.open(path, File.WRITE)
	emit_signal("game_save_started")
	_saver_loader.save_game(save_file, get_tree())
	
	yield(_saver_loader, "finished")
	
	emit_signal("game_save_finished")


func load_game(path: String) -> void:
	var save_file := File.new()
	
	save_file.open(path, File.READ)
	emit_signal("game_load_started")
	_saver_loader.load_game(save_file, get_tree())
	
	yield(_saver_loader, "finished")
	
	starting_new_game()



func starting_new_game():
	$popup.show()
