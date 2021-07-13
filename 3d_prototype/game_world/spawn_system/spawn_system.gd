class_name SpawnSystem
extends Position3D

export(String, FILE, "*.tscn") var _player_scene

onready var _ray_cast: RayCast = $RayCast



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.gameplay.connect("new_game", self, "_on_new_game")

func _exit_tree() -> void:
	Events.gameplay.disconnect("new_game", self, "_on_new_game")



func _on_new_game() -> void:
	var player_instance := _instantiate_scene(_player_scene)
	# warning-ignore:return_value_discarded
	player_instance.connect("tree_exiting", Events.player, "emit_signal", [ "player_freed" ])
	#Events.player.emit_signal("player_instantiated", player_instance)


func _instantiate_scene(scene_path: String) -> Spatial:
	var new_packed_scene := load(scene_path) as PackedScene
	assert(new_packed_scene)
	var new_scene := new_packed_scene.instance() as Spatial
	assert(new_scene)
	
	_ray_cast.enabled = true
	_ray_cast.force_raycast_update()
	owner.add_child(new_scene, true)
	
	new_scene.translation = _ray_cast.get_collision_point() if _ray_cast.get_collider() else translation
	new_scene.rotation = rotation
	
	_ray_cast.enabled = false
	return new_scene
