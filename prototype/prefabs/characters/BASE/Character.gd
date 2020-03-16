tool
extends Spatial
class_name Character

# Positions are abstracted using 2 dimensions
#	ring_radius, meaning how far the character is from the centre Vector3(0, 0, 0) and
#	ring_position, meaning the angle of the character when rotated around the centre Vector3(0, 0, 0)
export(float, -360, 360, 0.5) var ring_position:float = 0.0
export(float, 0, 100, 0.5) var ring_radius:float = 0.0

var radius_minimum:float = 12.0
var ring_width:float = 5.0

var walkspeed:float = 20.0
var up_down_modifier:float = 0.2
var sprint_modifier:float = 2.0

var sprinting:float = 1.0

var jump_speed:float = 20

var current_ring:int = 0
var can_move_rings:bool = false

signal moved
signal jumped


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)


func move(delta):
	ring_position += get_position_change(0) * delta
	rotation.y = deg2rad(ring_position)
	
	ring_radius += get_radius_change(0) * delta
	if not can_move_rings:
		ring_radius = clamp(ring_radius, current_ring * ring_width, (current_ring + 0.99) * ring_width)
	current_ring = int(ring_radius / ring_width)
	
	emit_signal("moved", Vector2(ring_position, ring_radius + radius_minimum))

func jump():
	emit_signal("jumped", jump_speed)


func get_position_change(velocity:float) -> float:
	return velocity * sprinting

func get_radius_change(vertical_velocity:float) -> float:
	 return vertical_velocity * up_down_modifier * sprinting
