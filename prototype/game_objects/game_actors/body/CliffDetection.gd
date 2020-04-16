class_name CliffDetection
extends Resource


enum Sides { DOWN, RIGHT, LEFT, UP }


var _down: float
var _width: float
var _up: float

var _raycast_length: float = -50.0

var _raycasts: Array = [ ]




# Called when the node enters the scene tree for the first time.
func _init(body: KinematicBody, new_down: float = 1.0, new_width: float = 3.0, new_up: float = 5.0):
	_down = new_down
	_width = new_width
	_up = new_up
	_create_raycasts(body)




func is_on_edge(side: int) -> bool:
	return not _raycasts[side].is_colliding()


func limit_movement(direction: Vector3) -> Vector3:
	if is_on_edge(Sides.DOWN):
		direction.x = min(direction.x, 0)
	
	if is_on_edge(Sides.RIGHT):
		direction.z = min(direction.z, 0)
	
	if is_on_edge(Sides.LEFT):
		direction.z = max(direction.z, 0)
	
	if is_on_edge(Sides.UP):
		direction.x = max(direction.x, 0)
	
	return direction




func _create_raycasts(body: KinematicBody):
	for side in Sides.keys():
		_create_raycast(Sides[side], side, body)


func _create_raycast(side: int, side_name: String, body: KinematicBody):
	var new_ray: RayCast = RayCast.new()
	body.add_child(new_ray)
	new_ray.name = side_name
	new_ray.enabled = true
	new_ray.cast_to.y = _raycast_length
	new_ray.set_collision_mask_bit(0, true)
	new_ray.set_collision_mask_bit(2, true)
	
	match side:
		Sides.DOWN:
			new_ray.transform.origin.z = _down
		Sides.RIGHT:
			new_ray.transform.origin.x = _width / 2.0
		Sides.LEFT:
			new_ray.transform.origin.x = -_width / 2.0
		Sides.UP:
			new_ray.transform.origin.z = -_up
	
	new_ray.transform.origin.y = 1
	
	_raycasts.append(new_ray)
