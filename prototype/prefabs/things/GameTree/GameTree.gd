extends GameObject
class_name GameTree

func is_class(type): return type == "GameTree" or .is_class(type)
func get_class(): return "GameTree"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.frame = randi() % 7




func set_ring_vector(new_vector:RingVector):
	.set_ring_vector(new_vector)
	rotation.y = ring_vector.rotation
	
	ring_map.register_thing(CityLayout.TREE, ring_vector, self)
	
	set_world_position(Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius))


func set_world_position(new_position:Vector3):
	$sprite.transform.origin = new_position



func get_world_position() -> Vector3:
	return $sprite.global_transform.origin
