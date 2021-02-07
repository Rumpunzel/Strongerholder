class_name WorldScene, "res://class_icons/game_objects/icon_world_scene.svg"
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := [ "name", "_first_time" ]


var main_node setget set_main_node


var _first_time: bool = true
var _objects_layer: ObjectsLayer




func set_main_node(new_main) -> void:
	main_node = new_main
	
	yield(main_node, "game_load_finished")
	
	if not _first_time:
		return
	
	_first_time = false
	
	_initialise_scene()




func _initialise_scene() -> void:
	var new_quarter_master := QuarterMaster.new()
	new_quarter_master.name = "QuarterMaster"
	add_child(new_quarter_master)
	
	var new_camera := PlayerCamera.new()
	new_camera.name = "PlayerCamera"
	add_child(new_camera)
	
	_objects_layer = ObjectsLayer.new()
	_objects_layer.name = "ObjectsLayer"
	add_child(_objects_layer)
	
	
	for i in range(5):
		for j in range(2):
			var player: GameActor = (load("res://game_objects/game_actors/game_actor.tscn") as PackedScene).instance()
			
			_objects_layer.add_child(player)
			player.global_position = Vector2(i * 32, j * 32)
			
			if i == 0 and j == 0:
				player.player_controlled = true
