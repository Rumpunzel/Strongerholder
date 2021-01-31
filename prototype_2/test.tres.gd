extends WorldScene


const SCENE := "res://test.tscn"



func _initialise_scene() -> void:
	for i in range(5):
		for j in range(2):
			var player: GameActor = preload("res://game_objects/game_actors/game_actor.tscn").instance()
			
			_objects_layer.add_child(player)
			player.global_position = Vector2(i * 32, j * 32)
			
			if i == 0 and j == 0:
				player.player_controlled = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float):
#	var tools_menu: ToolsMenu = $gui_layer/tools_menu
#
#	if tools_menu.visible:
#		var player: GameActor = $objects_layer/player
#
#		tools_menu.rect_position = player.get_global_transform_with_canvas().origin - tools_menu.rect_size / 2.0
