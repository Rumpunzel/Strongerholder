class_name GameWorld, "res://class_icons/game_objects/icon_world.svg"
extends Control


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false


signal object_selected




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func leave() -> void:
	pass
#	for child in get_children():
#		remove_child(child)
#		child.queue_free()


func enter_scene(main_node: Main, new_packed_scene: PackedScene, leave_previous_scene: bool = true):
	if leave_previous_scene:
		leave()
	
	#var new_scene: WorldScene = new_packed_scene.instance() as WorldScene
	
	$DefaultScene.main_node = main_node
	#add_child(new_scene)
	
	$DefaultScene.connect("object_selected", self, "_on_object_selected")


func is_in_game() -> bool:
	return get_child_count() > 0



func _on_object_selected(new_node: GameObject) -> void:
	emit_signal("object_selected", new_node)
