class_name PlayerCamera
extends Spatial


export var camera_distance: float = 15.0
export var stick_to_ground: bool = true


var node_to_follow: Spatial = null setget set_node_to_follow, get_node_to_follow


onready var camera = $camera
onready var ray_cast = RayCast.new()




# Called when the node enters the scene tree for the first time.
func _ready():
	ray_cast.enabled = true
	ray_cast.cast_to.y = -50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if node_to_follow and stick_to_ground:
		var rot_diff = node_to_follow.ring_vector.rotation - rotation.y
		
		while rot_diff > PI:
			rot_diff -= TAU
		
		while rot_diff < -PI:
			rot_diff += TAU
		
		rotation.y += rot_diff * delta * 5
		camera.transform.origin.z += (node_to_follow.ring_vector.radius + camera_distance - camera.transform.origin.z) * delta * 5
		camera.transform.origin.y += (ray_cast.get_collision_point().y - camera.transform.origin.y) * delta




func set_node_to_follow(new_node: Spatial):
	if node_to_follow:
		node_to_follow.remove_child(ray_cast)
	
	node_to_follow = new_node
	node_to_follow.add_child(ray_cast)
	ray_cast.transform.origin = Vector3(0, 1, 0)


func get_node_to_follow() -> Spatial:
	return node_to_follow
