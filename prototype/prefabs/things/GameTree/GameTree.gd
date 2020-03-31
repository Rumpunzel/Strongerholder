tool
extends GameObject
class_name GameTree

func is_class(type): return type == "GameTree" or .is_class(type)
func get_class(): return "GameTree"


var tree_offset:Vector3 = Vector3(0, 0, -3) setget set_tree_offset, get_tree_offset




func _ready():
	tree_offset += Vector3((randf() * 0.2 + (0.3 if randi() % 2 == 0 else -0.5)) * CityLayout.SEGMENT_WIDTH, 0, randf() * 2)




func set_tree_offset(new_offset:Vector3):
	tree_offset = new_offset


func set_ring_vector(new_vector:RingVector):
	.set_ring_vector(new_vector)
	rotation.y = ring_vector.rotation
	
	ring_map.register_thing(CityLayout.TREE, ring_vector, self)
	
	set_world_position(Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius))


func set_world_position(new_position:Vector3):
	$sprite.transform.origin = new_position + tree_offset
	print(ring_vector)
	ring_vector.rotation = Vector2(get_world_position().x, get_world_position().z).angle_to(Vector2.DOWN)
	print(ring_vector)



func get_tree_offset() -> Vector3:
	return tree_offset


func get_world_position() -> Vector3:
	return $sprite.global_transform.origin
