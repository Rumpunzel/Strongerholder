extends Spatial


const FRONT = "front"
const BACK = "back"
const LEFT = "left"
const RIGHT = "right"


export var raycast_length:float = 7.0
export var depth:float = 3.0
export var width:float = 3.0


var raycasts:Dictionary = { }



# Called when the node enters the scene tree for the first time.
func _ready():
	create_raycasts()



func create_raycasts():
	create_raycast(FRONT)
	create_raycast(BACK)
	create_raycast(LEFT)
	create_raycast(RIGHT)

func create_raycast(side:String):
	var new_ray = RayCast.new()
	add_child(new_ray)
	new_ray.name = side
	new_ray.enabled = true
	new_ray.cast_to.y = -raycast_length
	
	match side:
		FRONT:
			new_ray.transform.origin.z = -depth / 2.0
		BACK:
			new_ray.transform.origin.z = depth / 2.0
		LEFT:
			new_ray.transform.origin.x = -width / 2.0
		RIGHT:
			new_ray.transform.origin.x = width / 2.0
	
	new_ray.transform.origin.y = 1
	
	raycasts[side] = new_ray


func is_on_edge(side:String) -> bool:
	return not raycasts[side].is_colliding()