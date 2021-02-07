extends GUTTest



func test_game_class_scenes() -> void:
	var directory := Directory.new()
	var game_classes := [ ]
	
	for game_class_array in GameClasses.CLASSES.values():
		game_classes += game_class_array
	
	for game_class_name in game_classes:
		var game_class = GameClasses.get_script_constant_map()[game_class_name]
		
		assert_true(directory.file_exists(game_class.scene) and game_class.scene.get_extension() == "tscn", "The scene specified in %s is not correct!" % game_class_name)
