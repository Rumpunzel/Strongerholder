class_name GameCamera
extends Camera

const _ray_length := 1000.0

var follow_node: Spatial setget set_follow_node



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.player.connect("player_registered", self, "_on_player_registered")
	# warning-ignore:return_value_discarded
	Events.player.connect("player_unregistered", self, "_on_player_unregistered")

func _exit_tree() -> void:
	Events.player.disconnect("player_registered", self, "_on_player_registered")
	Events.player.disconnect("player_unregistered", self, "_on_player_unregistered")



func mouse_as_world_point() -> CameraRay:
	var mouse_position := get_viewport().get_mouse_position()
	var from := project_ray_origin(mouse_position)
	var to := from + project_ray_normal(mouse_position) * _ray_length
	return CameraRay.new(from, to)


func get_adjusted_movement(input_vector: Vector2) -> Vector3:
	var ajusted_movement: Vector3
	var camera_forward: Vector3 = transform.basis.z
	camera_forward.y = 0.0
	var camera_right: Vector3 = transform.basis.x
	camera_right.y = 0.0
	ajusted_movement = camera_right.normalized() * input_vector.x + camera_forward.normalized() * input_vector.y
	return ajusted_movement


#func save_to_var(save_file: File) -> void:
#	# Store node path
#	save_file.store_var(follow_node.get_path())

#func load_from_var(save_file: File) -> void:
#	# Load as node path
#	var node_path: String = save_file.get_var()
#	set_follow_node(get_node_or_null(node_path))


func set_follow_node(node: Spatial) -> void:
	follow_node = node
	if follow_node:
		_frame_node(follow_node)


func _on_player_registered(player_node: Character) -> void:
	assert(player_node)
	set_follow_node(player_node)

func player_unregistered(player_node: Character) -> void:
	if follow_node == player_node:
		set_follow_node(null)


func _frame_node(_node: Spatial) -> void:
	assert(false)



class CameraRay:
	var from: Vector3
	var to: Vector3
	
	func _init(new_from: Vector3, new_to: Vector3) -> void:
		from = new_from
		to = new_to
