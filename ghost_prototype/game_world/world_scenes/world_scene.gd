class_name WorldScene, "res://class_icons/game_objects/icon_world_scene.svg"
extends Control


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false

const PERSIST_PROPERTIES := [ "_first_time" ]


signal object_selected


var main_node setget set_main_node


var _first_time: bool = true


onready var _viewport: Viewport = $Viewport
onready var _objects_layer: ObjectsLayer = $Viewport/ObjectsLayer




func set_main_node(new_main) -> void:
	main_node = new_main
	
	yield(main_node, "game_load_finished")
	
	_objects_layer.connect("object_selected", self, "_on_object_selected")
	
	if not _first_time:
		return
	
	_first_time = false
	
	_initialise_scene()




func _initialise_scene() -> void:
	for i in range(5):
		for j in range(2):
			var player: GameActor = (load("res://game_objects/game_actors/game_actor.tscn") as PackedScene).instance()
			
			_objects_layer.add_child(player)
			player.global_position = Vector2(i * 32, j * 32)
			
			if i == 0 and j == 0:
				player.player_controlled = true
				
				var new_camera: PlayerCamera = (preload("res://game_world/player_camera.tscn").instance() as PlayerCamera)
				player.add_child(new_camera)


func _on_object_selected(new_node: GameObject) -> void:
	emit_signal("object_selected", new_node)
