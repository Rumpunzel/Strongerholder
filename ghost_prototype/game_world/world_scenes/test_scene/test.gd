extends WorldScene


const SCENE := "res://game_world/world_scenes/test_scene/test.tscn"


var test_scenes := [
	GameClasses.Beech,
	GameClasses.Workshop,
	GameClasses.Beech,
	GameClasses.Sawmill,
]
var test_positions := [
	Vector2(-192, -112),
	Vector2(192, -112),
	Vector2(192, 112),
	Vector2(-192, 112),
]



func _initialise_scene() -> void:
	._initialise_scene()
	
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
