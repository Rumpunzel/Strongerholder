extends Node


const _ray_length := 1000.0

var current_camera: GameCamera setget set_current_camera



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.player.connect("player_instantiated", self, "_on_player_instantiated")
	
	set_current_camera($MainCamera)

func _exit_tree() -> void:
	Events.player.disconnect("player_instantiated", self, "_on_player_instantiated")



func frame_node(node: Spatial) -> void:
	assert(node)
	current_camera.follow_node = node


func mouse_as_world_point() -> CameraRay:
	var mouse_position := get_viewport().get_mouse_position()
	var from := current_camera.project_ray_origin(mouse_position)
	var to := from + current_camera.project_ray_normal(mouse_position) * _ray_length
	return CameraRay.new(from, to)


func get_adjusted_movement(input_vector: Vector2) -> Vector3:
	var ajusted_movement: Vector3
	var camera_forward: Vector3 = current_camera.transform.basis.z
	camera_forward.y = 0.0
	var camera_right: Vector3 = current_camera.transform.basis.x
	camera_right.y = 0.0
	ajusted_movement = camera_right.normalized() * input_vector.x + camera_forward.normalized() * input_vector.y
	return ajusted_movement



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
	
	Events.player.emit_signal("camera_changed", current_camera)
	
	if follow_node:
		current_camera.follow_node = follow_node




class CameraRay:
	var from: Vector3
	var to: Vector3
	
	func _init(new_from: Vector3, new_to: Vector3) -> void:
		from = new_from
		to = new_to
