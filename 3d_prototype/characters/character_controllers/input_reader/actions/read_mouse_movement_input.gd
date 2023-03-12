extends ActionLeaf

onready var _current_camera: GameCamera = get_viewport().get_camera()

func on_update(blackboard: Occupation.OccupationBlackboard) -> int:
	var character := blackboard.character
	var navigation := character.get_navigation()
	var camera_ray := _current_camera.mouse_as_world_point()
	var navigation_point := navigation.get_closest_point_to_segment(camera_ray.from, camera_ray.to)
	
	# HACK: fixed Navigation always returning a point 0.4 over ground
	navigation_point.y = 0.0
	character.destination_input = navigation_point
	return Status.RUNNING
