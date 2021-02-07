class_name GameWorld, "res://class_icons/game_objects/icon_world.svg"
extends Node2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false


export(PackedScene) var default_scene := preload("res://game_world/world_scenes/test/test.tscn")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func leave() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()


func enter_scene(main_node: Main, new_packed_scene: PackedScene = default_scene, leave_previous_scene: bool = true):
	if leave_previous_scene:
		leave()
	
	var new_scene := new_packed_scene.instance() as WorldScene
	
	new_scene.main_node = main_node
	add_child(new_scene)


func is_in_game() -> bool:
	return get_child_count() > 0
