extends Node

const _ray_length := 1000.0

var current_camera: GameCamera setget set_current_camera

onready var _ray_cast: RayCast = $RayCast


func _enter_tree() -> void:
	var error := Events.connect("player_instantiated", self, "_on_player_instantiated")
	assert(error == OK)
	
	set_current_camera($MainCamera)

func _exit_tree() -> void:
	Events.disconnect("player_instantiated", self, "_on_player_instantiated")


func frame_node(node: Spatial) -> void:
	assert(node)
	current_camera.follow_node = node


func mouse_as_world_point() -> Vector3:
	var mouse_position := get_viewport().get_mouse_position()
	var origin := current_camera.project_ray_origin(mouse_position)
	_ray_cast.translation = origin
	_ray_cast.cast_to = origin + current_camera.project_ray_normal(mouse_position) * _ray_length
	return _ray_cast.get_collision_point()

func _on_player_instantiated(player_node: Spatial) -> void:
	assert(player_node)
	frame_node(player_node)


func set_current_camera(new_camera: GameCamera) -> void:
	assert(new_camera)
	var follow_node: Spatial = null
	
	if current_camera:
		follow_node = current_camera.follow_node
		current_camera.current = false
	
	current_camera = new_camera
	current_camera.current = true
	
	Events.emit_signal("camera_changed", current_camera)
	
	if follow_node:
		current_camera.follow_node = follow_node
