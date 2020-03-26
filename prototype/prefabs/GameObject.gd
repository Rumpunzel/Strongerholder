extends Spatial
class_name GameObject

func is_class(type): return type == "GameObject" or .is_class(type)
func get_class(): return "GameObject"



export var hit_points_max:float = 10.0
export var indestructible:bool = false


onready var hit_points:float = hit_points_max


# Positions are abstracted using 2 dimensions
#	ring_vector.x, meaning how far the gameactor is from the centre Vector3(0, 0, 0) and
#	ring_vector.y, meaning the angle (in radians) of the gameactor when rotated around the centre Vector3(0, 0, 0)
var ring_vector:RingVector = RingVector.new(0, 0) setget set_ring_vector, get_ring_vector

#warning-ignore:unused_class_variable
var world_position:Vector3 setget set_world_position, get_world_position

var highlighted:bool = false setget set_highlighted, get_highlighted


signal entered_segment



# Called when the node enters the scene tree for the first time.
func _ready():
	ring_vector.connect("vector_changed", self, "updated_ring_vector")
	
	var rad = global_transform.origin.distance_to(Vector3())
	var rot = Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2.DOWN)
	var vec = RingVector.new(rad, rot)
	
	set_ring_vector(vec)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func updated_ring_vector():
	emit_signal("entered_segment", ring_vector)


func handle_highlighted():
	pass


func interact(_sender:GameObject, _action:String):
	pass


func damage(_sender, damage_points:float):
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
	return global_transform.origin


func get_highlighted() -> bool:
	return highlighted
