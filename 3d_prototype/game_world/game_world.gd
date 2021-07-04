class_name GameWorld
extends Spatial


var _current_scene = null


func leave() -> void:
	assert(_current_scene)
	
	remove_child(_current_scene)
	_current_scene.queue_free()


func enter_scene(_new_scene: String, leave_previous_scene: bool = true):
	if leave_previous_scene:
		leave()
	
	#var new_scene: WorldScene = new_packed_scene.instance() as WorldScene
	
	#$DefaultScene.main_node = main_node
	#add_child(new_scene)
	
	#$DefaultScene.connect("object_selected", self, "_on_object_selected")


func is_in_game() -> bool:
	return not _current_scene == null
