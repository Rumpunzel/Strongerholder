class_name SpawnSystem
extends Position3D

export(PackedScene) var _player_scene

export var _height_offset: float = 0.0



func _enter_tree() -> void:
	var error := Events.connect("scene_loaded", self, "_on_scene_loaded")
	assert(error == OK)

func _exit_tree() -> void:
	Events.disconnect("scene_loaded", self, "_on_scene_loaded")



func _on_scene_loaded() -> void:
	var player_instance := _instantiate_scene(_player_scene)
	
	Events.emit_signal("player_instantiated", player_instance)


func _instantiate_scene(scene: PackedScene) -> Spatial:
	assert(scene)
	var new_scene := scene.instance() as Spatial
	
	owner.add_child(new_scene)
	new_scene.transform.origin = self.transform.origin + Vector3.UP * _height_offset
	new_scene.rotation = self.rotation
	
	return new_scene