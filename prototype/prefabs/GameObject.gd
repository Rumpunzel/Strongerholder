extends Spatial
class_name GameObject


# Positions are abstracted using 2 dimensions
#	ring_radius, meaning how far the character is from the centre Vector3(0, 0, 0) and
#	ring_position, meaning the angle (in degrees) of the character when rotated around the centre Vector3(0, 0, 0)
export(float, 0, 128, 0.5) var ring_radius:float = 0.0 setget set_ring_radius, get_ring_radius
export(float, 0, 6.3, 0.1) var ring_position:float = 0.0 setget set_ring_position, get_ring_position


onready var hit_points:float = hit_points_max


# The current ring of the world the character is on
#	rings start with 0
var current_ring:int = 0
var current_segment:int = 0

var hit_points_max:float = 10.0

var highlighted:bool = false setget set_highlighted, get_highlighted


signal entered_segment
signal left_segment



# Called when the node enters the scene tree for the first time.
func _ready():
	update_ring_vector(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_highlighted()



func update_ring_vector(emit_update:bool = false):
	var new_ring:int = GameConstants.get_current_ring(ring_radius)
	var new_segment:int = GameConstants.get_current_segment(ring_position, ring_radius)
	
	if emit_update or not new_ring == current_ring or not new_segment == current_segment:
		emit_signal("entered_segment", Vector2(new_ring, new_segment))
		emit_signal("left_segment", Vector2(current_ring, current_segment))
		
		current_ring = new_ring
		current_segment = new_segment


func highlight(_sender):
	set_highlighted(true)

func unhighlight(_sender):
	set_highlighted(false)

func handle_highlighted():
	pass


func interact(_sender, _action):
	pass

func damage(_sender, damage_points:float):
	hit_points -= damage_points



func world_position() -> Vector3:
	return global_transform.origin


func set_ring_radius(new_radius:float):
	ring_radius = new_radius
	update_ring_vector()

func set_ring_position(new_position:float):
	ring_position = new_position
	update_ring_vector()

func set_highlighted(is_highlighted:bool):
	highlighted = is_highlighted


func get_ring_radius() -> float:
	return ring_radius

func get_ring_position() -> float:
	return ring_position

func get_highlighted() -> bool:
	return highlighted
