class_name PlayerCamera
extends Camera


export var camera_distance: float = 15.0
export var camera_angle: float = -2.0

export var stick_to_ground: bool = true
export var listener_off_ground: float = 5.0

export var camera_speed:float = 3.0

var node_to_follow: Spatial = null setget set_node_to_follow, get_node_to_follow


onready var ray_cast: RayCast = RayCast.new()
onready var listener: Listener = Listener.new()

onready var ui = $ui_layer/control/margin_container
onready var control_layer = $ui_layer/control




# Called when the node enters the scene tree for the first time.
func _ready():
	rotation.x = deg2rad(camera_angle)
	
	ray_cast.enabled = true
	ray_cast.cast_to.y = -50
	
	listener.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if node_to_follow:
		var new_y: float = 0.0
		
		if stick_to_ground:
			new_y = ray_cast.get_collision_point().y
		
		var new_z: float = node_to_follow.ring_vector.radius + camera_distance
		
		var new_origin: Vector3 = Vector3(0, new_y, new_z).rotated(Vector3.UP, node_to_follow.ring_vector.rotation)
		
		transform.origin.x += (new_origin.x - transform.origin.x) * delta * camera_speed
		transform.origin.y += (new_origin.y - transform.origin.y) * delta
		transform.origin.z += (new_origin.z - transform.origin.z) * delta * camera_speed
		
		rotation.y = atan2(transform.origin.x, transform.origin.z)




func add_ui_element(new_element: Control, center_ui: bool = true):
	var new_parent = ui if center_ui else control_layer
	
	new_parent.add_child(new_element)


func set_node_to_follow(new_node: Spatial):
	if node_to_follow:
		node_to_follow.remove_child(ray_cast)
		node_to_follow.remove_child(listener)
	
	node_to_follow = new_node
	node_to_follow.add_child(ray_cast)
	ray_cast.transform.origin = Vector3(0, 1, 0)
	
	node_to_follow.add_child(listener)
	listener.transform.origin = Vector3(0, listener_off_ground, 0)


func get_node_to_follow() -> Spatial:
	return node_to_follow
