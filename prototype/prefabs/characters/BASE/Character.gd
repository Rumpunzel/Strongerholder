tool
extends Spatial
class_name Character

# Positions are abstracted using 2 dimensions
#	ring_radius, meaning how far the character is from the centre Vector3(0, 0, 0) and
#	ring_position, meaning the angle (in degrees) of the character when rotated around the centre Vector3(0, 0, 0)
export(float, -360, 360, 0.5) var ring_position:float = 0.0
export(float, 0, 100, 0.5) var ring_radius:float = 0.0

# The minum radius in world distance a character can travel towards the centre Vector3(0, 0, 0)
var radius_minimum:float = 12.0
# The width of a ring in world distance
#	the world is organized in concetric rings around the centre and traveling from ring to ring is only possible in specail cases
var ring_width:float = 5.0

var walkspeed:float = 20.0
# Modifier to the speed when walking up or down to help the 2.5D illusion
var up_down_modifier:float = 0.2
var sprint_modifier:float = 2.0

# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the character is walking normal
var sprinting:float = 1.0

var jump_speed:float = 20

# The current ring of the world the character is on
#	rings start with 0
var current_ring:int = 0
# If the character is able to move between rings, e.g. when using a bridge
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
	# Called with the paramter 0 as the according function needs to be implemented by child classes
	ring_position += get_position_change(0) * delta
	rotation.y = deg2rad(ring_position)
	
	# Called with the paramter 0 as the according function needs to be implemented by child classes
	ring_radius += get_radius_change(0) * delta
	# Limiting of the movement between rings
	if not can_move_rings:
		ring_radius = clamp(ring_radius, current_ring * ring_width, (current_ring + 0.99) * ring_width)
	# Recalculation of the current ring the character is on
	current_ring = int(ring_radius / ring_width)
	
	# The position in the world can be displayed with a Vector2
	#	with the x-axis being the ring_position and
	#	with the y-axis being the ring_radius
	emit_signal("moved", Vector2(ring_position, ring_radius + radius_minimum))

func jump():
	emit_signal("jumped", jump_speed)


# This function has to be implemented by child classes
func get_position_change(velocity:float) -> float:
	return velocity * sprinting

# This function has to be implemented by child classes
func get_radius_change(vertical_velocity:float) -> float:
	 return vertical_velocity * up_down_modifier * sprinting
