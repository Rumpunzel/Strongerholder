class_name SpawnSystem
extends Position3D

export(String, FILE, "*.tscn") var _player_scene

onready var _ray_cast: RayCast = $RayCast



func _enter_tree() -> void:
	var error := Events.connect("scene_loaded", self, "_on_scene_loaded")
	assert(error == OK)

func _exit_tree() -> void:
	Events.disconnect("scene_loaded", self, "_on_scene_loaded")



func _on_scene_loaded() -> void:
	var player_instance := _instantiate_scene(_player_scene)
	
	Events.emit_signal("player_instantiated", player_instance)


func _instantiate_scene(scene_path: String) -> Spatial:
	var new_packed_scene := load(scene_path) as PackedScene
	assert(new_packed_scene)
	var new_scene := new_packed_scene.instance() as Spatial
	assert(new_scene)
	
	owner.add_child(new_scene)
	# TODO: find out why this raycast is not returning valid data
	new_scene.translation = translation#_ray_cast.get_collision_point()
	new_scene.rotation = rotation
	
	return new_scene
