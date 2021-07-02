class_name TopDownCamera
extends GameCamera

export(Resource) var _attributes


var _position: Vector3 = Vector3()
var _offset: Vector3 = Vector3()

var _angle_offset: float = 0.0
var _turn_angle: float = 0.0

var _angle: float = 0.0
var _turnIndex: int = 0

var _zoom: float = 1.0



func _ready() -> void:
	_angle_offset = deg2rad(_attributes.camera_angle_offset)
	_turn_angle = deg2rad(_attributes.camera_turn_angle)
	
	_angle = _attributes.camera_angle_offset


func _process(_delta: float) -> void:
	fov = _attributes.fov
	
	if follow_node:
		_frame_node(follow_node)



func rotate_left() -> void:
	_turnIndex -= 1

func rotate_right() -> void:
	_turnIndex += 1


func _frame_node(node: Spatial) -> void:
	_angle = _turnIndex * _turn_angle + _angle_offset
	
	_offset.x = _attributes.distance_from_follow * cos(_angle)
	_offset.z = _attributes.distance_from_follow * sin(_angle)
	
	_position = node.transform.origin + _offset
	_position.y = _attributes.shoulder_height + _attributes.distance_off_ground * _zoom
	
	transform.origin = _position
	look_at(Vector3(node.transform.origin.x, _attributes.shoulder_height, node.transform.origin.z), Vector3.UP)
