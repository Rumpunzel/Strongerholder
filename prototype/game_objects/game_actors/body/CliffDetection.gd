class_name CliffDetection
extends Resource


enum Sides { DOWN, RIGHT, LEFT, UP }


var down: float
var width: float
var up: float

var raycast_length: float = -50.0

var raycasts: Array = [ ]



# Called when the node enters the scene tree for the first time.
func _init(body: KinematicBody, new_down: float = 1.0, new_width: float = 3.0, new_up: float = 5.0):
	down = new_down
	width = new_width
	up = new_up
	create_raycasts(body)



func create_raycasts(body: KinematicBody):
	for side in Sides.keys():
		create_raycast(Sides[side], side, body)


func create_raycast(side: int, side_name: String, body: KinematicBody):
	var new_ray = RayCast.new()
	body.add_child(new_ray)
	new_ray.name = side_name
	new_ray.enabled = true
	new_ray.cast_to.y = raycast_length
	
	match side:
		Sides.DOWN:
			new_ray.transform.origin.z = down
		Sides.RIGHT:
			new_ray.transform.origin.x = width / 2.0
		Sides.LEFT:
			new_ray.transform.origin.x = -width / 2.0
		Sides.UP:
			new_ray.transform.origin.z = -up
	
	new_ray.transform.origin.y = 1
	
	raycasts.append(new_ray)


func is_on_edge(side: int) -> bool:
	return not raycasts[side].is_colliding()


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
