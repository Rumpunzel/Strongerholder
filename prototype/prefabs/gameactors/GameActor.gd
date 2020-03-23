tool
extends GameObject
class_name GameActor


onready var body = $body


var walkspeed:float = 0.05
# Modifier to the speed when walking up or down to help the 2.5D illusion
var vertical_walkspeed:float = 0.025
#warning-ignore:unused_class_variable
var sprint_modifier:float = 2.5

var walking_direction:Vector2 = Vector2()

# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var movement_modifier:float = 1.0

var jump_speed:float = 30.0

# If the gameactor is able to move between rings, e.g. when using a bridge
var movement_limit:Array = [ [ ], [ ] ] setget set_movement_limit, get_movement_limit
#warning-ignore:unused_class_variable
var current_path:Array = [ ]


signal moved
signal jumped



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func move_to(direction:Vector2, sprinting:bool):
	movement_modifier = sprint_modifier if sprinting else 1.0
	
	ring_radius += get_position_change(direction).x
	
	ring_position += get_position_change(direction).y
	ring_position = modulo_ring_vector(Vector2(0, ring_position)).y
	
	# Limiting of the movement between rings
	if not Engine.editor_hint:
		if not movement_limit[0].empty():
			ring_radius = clamp(ring_radius, movement_limit[0][0], movement_limit[0][1])
		
		if not movement_limit[1].empty():
			ring_position = clamp(ring_position, movement_limit[1][0], movement_limit[1][1])
	
	update_ring_vector()
	
	body.ring_radius = ring_radius + RingMap.BASE_RADIUS
	rotation.y = ring_position
	
	
	var radius_minimum = RingMap.get_radius_minimum(current_ring) - RingMap.BASE_RADIUS
	var ring_width = RingMap.RING_WIDTH - RingMap.RING_GAP
	
	if movement_limit[0].empty() and movement_limit[1].empty() and ring_radius > radius_minimum and ring_radius < radius_minimum + ring_width:
		update_movement_limit(Vector2(current_ring, current_segment))
	
	# The position in the world can be displayed with a Vector2
	#	with the x-axis being the ring_position and
	#	with the y-axis being the ring_radius
	emit_signal("moved", Vector2(ring_position, ring_radius + RingMap.BASE_RADIUS))
	
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
	
	return Vector2(direction.x * vertical_walkspeed, direction.y * walkspeed / max(1, ring_radius + RingMap.BASE_RADIUS)) * movement_modifier


func update_movement_limit(new_position:Vector2):
	var radius_minimum = RingMap.get_radius_minimum(int(new_position.x)) - RingMap.BASE_RADIUS
	var radius_maximum = RingMap.get_radius_maximum(int(new_position.x)) - RingMap.BASE_RADIUS

	movement_limit[0] = [radius_minimum, radius_maximum]
	movement_limit[1] = [ ]


func update_current_path(_new_position:Vector2):
	pass



func set_movement_limit(new_limit:Array):
	movement_limit = new_limit


func get_movement_limit() -> Array:
	return movement_limit
