class_name GameCamera
extends Camera

var follow_node: Spatial setget set_follow_node


func set_follow_node(node: Spatial) -> void:
	assert(node)
	follow_node = node
	_frame_node(follow_node)


func _frame_node(_node: Spatial) -> void:
	assert(false)
