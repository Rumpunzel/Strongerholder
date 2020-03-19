tool
extends GameObject
class_name Character


# Positions are abstracted using 2 dimensions
#	ring_radius, meaning how far the character is from the centre Vector3(0, 0, 0) and
#	ring_position, meaning the angle (in degrees) of the character when rotated around the centre Vector3(0, 0, 0)
export(float, 0, 6.3, 0.1) var ring_position:float = 0.0
export(float, 0, 128, 0.5) var ring_radius:float = 0.0


onready var body = $body


var walkspeed:float = 3.0
# Modifier to the speed when walking up or down to help the 2.5D illusion
var vertical_walkspeed:float = 2.0
var sprint_modifier:float = 1.5

# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the character is walking normal
var sprinting:float = 1.0

var jump_speed:float = 30.0

# The current ring of the world the character is on
#	rings start with 0
var current_ring:int = -1
# If the character is able to move between rings, e.g. when using a bridge
var can_move_rings:bool = false
var current_segment:int = -1


signal moved
signal jumped

signal entered_segment
signal left_segment



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)



func move(delta):
	var radius_minimum = GameConstants.get_radius_minimum(current_ring) - GameConstants.BASE_RADIUS
	var ring_width = GameConstants.get_ring_width()
	
	# Called with the paramter 0 as the according function needs to be implemented by child classes
	ring_position += get_position_change(0) * delta
	
	while ring_position < 0:
		ring_position += TAU
	
	rotation.y = ring_position
	
	# Called with the paramter 0 as the according function needs to be implemented by child classes
	ring_radius += get_radius_change(0) * delta
	
	# Limiting of the movement between rings
	if not can_move_rings and not Engine.editor_hint:
		ring_radius = clamp(ring_radius, radius_minimum, radius_minimum + ring_width * GameConstants.RING_GAP)
	
	
	var new_ring:int = GameConstants.get_current_ring(ring_radius)
	var new_segment:int = GameConstants.get_current_segment(ring_position, ring_radius)
	
	if not new_ring == current_ring or not new_segment == current_segment:
		emit_signal("entered_segment", Vector2(new_ring, new_segment))
		emit_signal("left_segment", Vector2(current_ring, current_segment))
		
		current_ring = new_ring
		current_segment = new_segment
	
	body.ring_radius = ring_radius + GameConstants.BASE_RADIUS
	
	# The position in the world can be displayed with a Vector2
	#	with the x-axis being the ring_position and
	#	with the y-axis being the ring_radius
	emit_signal("moved", Vector2(ring_position, ring_radius + GameConstants.BASE_RADIUS))
	
	radius_minimum = GameConstants.get_radius_minimum(current_ring) - GameConstants.BASE_RADIUS
	
	if ring_radius > radius_minimum and ring_radius < radius_minimum + ring_width * GameConstants.RING_GAP:
		can_move_rings = false
	
	#print("current_ring: %d" % [current_ring])
	#print("current_segment: %d" % [current_segment])


func jump():
	body.jump(jump_speed)
	
	emit_signal("jumped")


# This function has to be implemented by child classes
func get_position_change(velocity:float) -> float:
	if Engine.editor_hint:
		velocity = 0
	
	return (velocity * sprinting * walkspeed) / (ring_radius + GameConstants.BASE_RADIUS)

# This function has to be implemented by child classes
func get_radius_change(vertical_velocity:float) -> float:
	if Engine.editor_hint:
		vertical_velocity = 0
		
	return vertical_velocity * sprinting * vertical_walkspeed
