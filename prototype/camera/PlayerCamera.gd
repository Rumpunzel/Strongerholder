class_name PlayerCamera
extends Camera


export var _camera_distance: float = 15.0
export var _camera_angle: float = -2.0

export var _stick_to_ground: bool = true
export var _listener_off_ground: float = 1.0

export var _camera_speed:float = 3.0

var node_to_follow: Spatial = null setget set_node_to_follow


onready var _ray_cast: RayCast = RayCast.new()
onready var _listener: Listener = Listener.new()

onready var _ui = $ui_layer/control/margin_container
onready var _control_layer = $ui_layer/control




# Called when the node enters the scene tree for the first time.
func _ready():
	rotation.x = deg2rad(_camera_angle)
	
	_ray_cast.enabled = true
	_ray_cast.set_collision_mask_bit(2, true)
	_ray_cast.cast_to.y = -50
	
	_listener.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if node_to_follow:
		var new_y: float = 0.0
		
		if _stick_to_ground:
			new_y = _ray_cast.get_collision_point().y
		
		var new_z: float = CityLayout.get_radius_minimum(node_to_follow.ring_vector.ring) + _camera_distance
		
		var new_origin: Vector3 = Vector3(0, new_y, new_z).rotated(Vector3.UP, node_to_follow.ring_vector.rotation)
		
		transform.origin.x += (new_origin.x - transform.origin.x) * delta * _camera_speed
		transform.origin.y += (new_origin.y - transform.origin.y) * delta
		transform.origin.z += (new_origin.z - transform.origin.z) * delta * _camera_speed
		
		rotation.y = atan2(transform.origin.x, transform.origin.z)




func add_ui_element(new_element: Control, center_ui: bool = true):
	var new_parent = _ui if center_ui else _control_layer
	
	new_parent.add_child(new_element)




func set_node_to_follow(new_node: Spatial):
	if node_to_follow:
		node_to_follow.remove_child(_ray_cast)
		node_to_follow.remove_child(_listener)
	
	node_to_follow = new_node
	node_to_follow.add_child(_ray_cast)
	_ray_cast.transform.origin = Vector3(0, 1, 0)
	
	node_to_follow.add_child(_listener)
	_listener.transform.origin = Vector3(0, _listener_off_ground, 0)
	
	transform.origin = Vector3(0, 0, CityLayout.get_radius_minimum(node_to_follow.ring_vector.ring) + _camera_distance).rotated(Vector3.UP, node_to_follow.ring_vector.rotation)
