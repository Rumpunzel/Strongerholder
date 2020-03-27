tool
extends Spatial
class_name GameObject

func is_class(type): return type == "GameObject" or .is_class(type)
func get_class(): return "GameObject"


export var hit_points_max:float = 10.0
export var indestructible:bool = false


onready var hit_points:float = hit_points_max


# Reference to the ring_map; pseudo Singleton only availably to GameObjects
var ring_map:RingMap
# The position of the object in ring vector space
#	for further information, look into the documentation in the RingVector class
var ring_vector:RingVector = RingVector.new(0, 0) setget set_ring_vector, get_ring_vector

# The global position of the object in world space
#	This will often be overwritten to give the global position of child nodes
# warning-ignore:unused_class_variable
var world_position:Vector3 setget set_world_position, get_world_position

var highlighted:bool = false setget set_highlighted, get_highlighted


signal entered_segment



func _init(new_ring_map:RingMap = null):
	ring_map = new_ring_map


# Called when the node enters the scene tree for the first time.
func _ready():
	ring_vector.connect("vector_changed", self, "updated_ring_vector")


func setup(new_ring_map:RingMap):
	ring_map = new_ring_map



func updated_ring_vector():
	emit_signal("entered_segment", ring_vector)


func handle_highlighted():
	pass


func interact(_sender:GameObject, _action:String) -> bool:
	return false


func damage(_sender:GameObject, damage_points:float):
	hit_points -= damage_points
	
	if not indestructible and hit_points <= 0:
		die()


func die():
	pass




func set_ring_vector(new_vector:RingVector):
	ring_vector.set_equal_to(new_vector)


func set_world_position(new_position:Vector3):
	global_transform.origin = new_position


func set_highlighted(is_highlighted:bool):
	highlighted = is_highlighted
	handle_highlighted()



func get_ring_vector() -> RingVector:
	return ring_vector

func get_world_position() -> Vector3:
	if is_inside_tree():
		return global_transform.origin
	else:
		return Vector3()


func get_highlighted() -> bool:
	return highlighted
