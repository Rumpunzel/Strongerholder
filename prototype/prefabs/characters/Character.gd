tool
extends GameObject
class_name Character


onready var body = $body


var walkspeed:float = 3.0
# Modifier to the speed when walking up or down to help the 2.5D illusion
var vertical_walkspeed:float = 2.0
#warning-ignore:unused_class_variable
var sprint_modifier:float = 1.5

# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the character is walking normal
var sprinting:float = 1.0

var jump_speed:float = 30.0

# If the character is able to move between rings, e.g. when using a bridge
var can_move_rings:bool = false
#warning-ignore:unused_class_variable
var current_path:Array = [ ]


signal moved
signal jumped



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(Vector2(), delta)



func move(direction:Vector2, delta:float):
	var radius_minimum = RingMap.get_radius_minimum(current_ring) - RingMap.BASE_RADIUS
	var ring_width = RingMap.RING_WIDTH - RingMap.RING_GAP
	
	# Called with the paramter 0 as the according function needs to be implemented by child classes
	ring_position += get_position_change(direction).y * delta
	
	while ring_position < 0:
		ring_position += TAU
	
	rotation.y = ring_position
	
	# Called with the paramter 0 as the according function needs to be implemented by child classes
	ring_radius += get_position_change(direction).x * delta
	
	# Limiting of the movement between rings
	if not can_move_rings and not Engine.editor_hint:
		ring_radius = clamp(ring_radius, radius_minimum, radius_minimum + ring_width)
	
	update_ring_vector()
	
	body.ring_radius = ring_radius + RingMap.BASE_RADIUS
	
	# The position in the world can be displayed with a Vector2
	#	with the x-axis being the ring_position and
	#	with the y-axis being the ring_radius
	emit_signal("moved", Vector2(ring_position, ring_radius + RingMap.BASE_RADIUS))
	
	radius_minimum = RingMap.get_radius_minimum(current_ring) - RingMap.BASE_RADIUS
	
	if ring_radius > radius_minimum and ring_radius < radius_minimum + ring_width:
		can_move_rings = false
	
	#print("current_ring: %d" % [current_ring])
	#print("current_segment: %d" % [current_segment])


func jump():
	body.jump(jump_speed)
	
	emit_signal("jumped")


# This function has to be implemented by child classes
func get_position_change(direction:Vector2) -> Vector2:
	if not Engine.editor_hint:
		direction = direction.normalized()
	else:
		direction = Vector2()
	
	return Vector2(direction.x * vertical_walkspeed, direction.y * walkspeed / (ring_radius + RingMap.BASE_RADIUS)) * sprinting


func update_current_path(_new_position:Vector2):
	pass

