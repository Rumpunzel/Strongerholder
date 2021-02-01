class_name WorldScene, "res://class_icons/game_objects/icon_world_scene.svg"
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false

const PERSIST_PROPERTIES := ["name", "_first_time"]


var _first_time: bool = true


onready var _main_node := get_tree().current_scene as Main
onready var _objects_layer = ServiceLocator.objects_layer




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(_main_node, "game_load_finished")
	
	if not _first_time:
		return
	
	_first_time = false
	
	_initialise_scene()




func _initialise_scene() -> void:
	for i in range(5):
		for j in range(2):
			var player: GameActor = load("res://game_objects/game_actors/game_actor.tscn").instance()
			
			_objects_layer.add_child(player)
			player.global_position = Vector2(i * 32, j * 32)
			
			if i == 0 and j == 0:
				player.player_controlled = true
