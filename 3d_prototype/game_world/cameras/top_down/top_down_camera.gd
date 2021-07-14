class_name TopDownCamera
extends GameCamera

export(Resource) var _attributes setget _set_attributes

var _position: Vector3 = Vector3()
var _offset: Vector3 = Vector3()

var _angle_offset: float = 0.0
var _turn_angle: float = 0.0

var _angle: float = 0.0
var _turnIndex: int = 0

var _zoom: float = 1.0
#var _tween: Tween



#func _enter_tree() -> void:
#	# warning-ignore:return_value_discarded
#	Events.main.connect("game_continued", self, "_on_game_continued")
#	_tween = $Tween
#	_zoom = _attributes.camera_max_zoom
#
#func _exit_tree() -> void:
#	Events.main.disconnect("game_continued", self, "_on_game_continued")


func _process(delta: float) -> void:
	if not _attributes:
		return
	
	#fov = _attributes.fov + (_attributes.shoulder_fov - _attributes.fov) * ((_zoom - _attributes.camera_min_zoom) / (_attributes.camera_max_zoom - _attributes.camera_min_zoom))
	
	if not follow_node:
		return
	
	_frame_node(follow_node, delta)



func rotate_left() -> void:
	_turnIndex -= 1

func rotate_right() -> void:
	_turnIndex += 1


#func save_to_var(save_file: File) -> void:
#	.save_to_var(save_file)
#	# Store resource path
#	save_file.store_var(_attributes.resource_path)

#func load_from_var(save_file: File) -> void:
#	.load_from_var(save_file)
#	# Load as resource
#	var resource_path: String = save_file.get_var()
#	var loaded_attributes: TopDownCameraAttributes = load(resource_path)
#	assert(loaded_attributes)
#	_attributes = loaded_attributes


func _frame_node(node: Spatial, _delta: float) -> void:
	_angle = _turnIndex * _turn_angle + _angle_offset
	
	var inverse_zoom := 1.0 / _zoom
	var zoom := sqrt(inverse_zoom)
	_offset.x = _attributes.distance_from_follow * cos(_angle) * zoom
	_offset.z = _attributes.distance_from_follow * sin(_angle) * zoom
	
	_position = node.translation + _offset
	_position.y = _attributes.shoulder_height + _attributes.distance_off_ground * inverse_zoom
	
	translation = _position
	
	look_at(Vector3(node.translation.x, _attributes.shoulder_height, node.translation.z), Vector3.UP)


#func _on_game_continued() -> void:
#	_set_zoom(_attributes.camera_min_zoom)


func _set_attributes(new_attributes: TopDownCameraAttributes) -> void:
	_attributes = new_attributes
	
	_angle_offset = deg2rad(_attributes.camera_angle_offset)
	_turn_angle = deg2rad(_attributes.camera_turn_angle)
	
	_angle = _attributes.camera_angle_offset

#func _set_zoom(new_zoom: float) -> void:
#	new_zoom = clamp(new_zoom, _attributes.camera_min_zoom, _attributes.camera_max_zoom)
#
#	if _zoom >= _attributes.camera_min_zoom:
#		# warning-ignore:return_value_discarded
#		_tween.interpolate_property(self, "_zoom", null, new_zoom, _attributes.camera_scroll_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
#		# warning-ignore:return_value_discarded
#		_tween.start()
#	else:
#		_zoom = new_zoom
