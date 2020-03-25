tool
extends Spatial
class_name GameObject

func is_class(type): return type == "GameObject" or .is_class(type)
func get_class(): return "GameObject"


# Positions are abstracted using 2 dimensions
#	ring_radius, meaning how far the gameactor is from the centre Vector3(0, 0, 0) and
#	ring_position, meaning the angle (in degrees) of the gameactor when rotated around the centre Vector3(0, 0, 0)

export var hit_points_max:float = 10.0


onready var hit_points:float = hit_points_max


var ring_vector:Vector2 = Vector2() setget set_ring_vector, get_ring_vector
# The current ring of the world the gameactor is on
#	rings start with 0
var current_ring:int = 0
var current_segment:int = 0

#warning-ignore:unused_class_variable
var world_position:Vector3 setget set_world_position, get_world_position

var highlighted:bool = false setget set_highlighted, get_highlighted


signal entered_segment
signal left_segment



# Called when the node enters the scene tree for the first time.
func _ready():
	update_ring_vector(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func update_ring_vector(emit_update:bool = false):
	var new_ring:int = RingMap.get_current_ring(ring_vector.x)
	var new_segment:int = RingMap.get_current_segment(ring_vector)
	
	if emit_update or not new_ring == current_ring or not new_segment == current_segment:
		emit_signal("entered_segment", Vector2(new_ring, new_segment))
		emit_signal("left_segment", Vector2(current_ring, current_segment))
	
	current_ring = new_ring
	current_segment = new_segment


static func modulo_ring_vector(new_ring_vector:Vector2) -> Vector2:
	while new_ring_vector.y > PI:
		new_ring_vector.y -= TAU
	
	while new_ring_vector.y < -PI:
		new_ring_vector.y += TAU
	
	return new_ring_vector


func handle_highlighted():
	pass


func interact(_sender:GameObject, _action:String):
	pass

func damage(_sender, damage_points:float):
	hit_points -= damage_points




func set_ring_vector(new_vector:Vector2):
	ring_vector = new_vector
	update_ring_vector()


func set_world_position(new_position:Vector3):
	global_transform.origin = new_position


func set_highlighted(is_highlighted:bool):
	highlighted = is_highlighted
	handle_highlighted()



func get_ring_vector() -> Vector2:
	return ring_vector


func get_world_position() -> Vector3:
	return global_transform.origin


func get_highlighted() -> bool:
	return highlighted
