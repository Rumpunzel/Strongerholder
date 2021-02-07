extends WorldScene


const SCENE := "res://game_world/world_scenes/test_scene/test.tscn"


var test_scenes := [
	GameClasses.Beech,
	GameClasses.Sawmill,
	GameClasses.Beech,
	GameClasses.WoodcuttersHut,
]
var test_positions := [
	Vector2(-192, -112),
	Vector2(192, -112),
	Vector2(192, 112),
	Vector2(-192, 112),
]



func _initialise_scene() -> void:
	for i in range(5):
		for j in range(2):
			var player: GameActor = (load("res://game_objects/game_actors/game_actor.tscn") as PackedScene).instance() as GameActor
			
			_objects_layer.add_child(player)
			player.global_position = Vector2(i * 32, j * 32)
			
			if i == 0 and j == 0:
				player.player_controlled = true
	
	
	for i in test_scenes.size():
		var new_scene: Structure = test_scenes[i].spawn() as Structure
		
		_objects_layer.add_child(new_scene)
		new_scene.global_position = test_positions[i]



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float):
#	var tools_menu: ToolsMenu = $gui_layer/tools_menu
#
#	if tools_menu.visible:
#		var player: GameActor = $objects_layer/player
#
#		tools_menu.rect_position = player.get_global_transform_with_canvas().origin - tools_menu.rect_size / 2.0
