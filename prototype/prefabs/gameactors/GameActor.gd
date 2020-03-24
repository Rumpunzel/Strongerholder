extends GameObject
class_name GameActor


onready var body:KinematicBody = $body
onready var cliff_dection = $body/cliff_detection
onready var pathfinder = $pathfinder


export var walkspeed:float = 3.0
export var sprint_modifier:float = 2.5
export var jump_speed:float = 30.0


# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var movement_modifier:float = 1.0

var pathfinding_target:Vector2 = Vector2() setget set_pathfinding_target, get_pathfinding_target


signal moved
signal jumped
signal stopped_jumping



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func move_to(direction:Vector2, sprinting:bool):
	movement_modifier = sprint_modifier if sprinting else 1.0
	
	body.move_direction = get_move_direction(direction)
	ring_vector = body.ring_vector
	
	update_ring_vector()
	
	# The position in the world can be displayed with a Vector2
	#	with the x-axis being the ring_position and
	#	with the y-axis being the ring_radius
	emit_signal("moved", ring_vector)
	
	#print("current_ring: %d" % [current_ring])
	#print("current_segment: %d" % [current_segment])


# This function has to be implemented by child classes
func get_move_direction(direction:Vector2) -> Vector2:
	if cliff_dection.is_on_edge(cliff_dection.FRONT):
		direction.x = max(direction.x, 0)
	
	if cliff_dection.is_on_edge(cliff_dection.BACK):
		direction.x = min(direction.x, 0)
	
	if cliff_dection.is_on_edge(cliff_dection.LEFT):
		direction.y = max(direction.y, 0)
	
	if cliff_dection.is_on_edge(cliff_dection.RIGHT):
		direction.y = min(direction.y, 0)
	
	return direction * walkspeed * movement_modifier



func jump():
	body.jump(jump_speed)
	
	emit_signal("jumped")

func stop_jump():
	body.jump()
	
	emit_signal("stopped_jumping")



func get_world_position():
	return body.global_transform.origin




func set_pathfinding_target(new_target:Vector2):
	pathfinding_target = new_target
	pathfinder.pathfinding_target = pathfinding_target



func get_pathfinding_target() -> Vector2:
	return pathfinding_target
