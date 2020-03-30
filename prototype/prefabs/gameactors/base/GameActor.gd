extends GameObject
class_name GameActor

func is_class(type): return type == "GameActor" or .is_class(type)
func get_class(): return "GameActor"


onready var body:KinematicBody = $body
onready var sprite:Sprite3D = $body/sprite
onready var cliff_dection = $body/cliff_detection
onready var pathfinder = $pathfinder


export var walkspeed:float = 3.0
export var sprint_modifier:float = 2.5
export var jump_speed:float = 30.0


# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var movement_modifier:float = 1.0

var pathfinding_target:RingVector setget set_pathfinding_target, get_pathfinding_target

var focus_target:GameObject = null setget set_focus_target, get_focus_target


signal moved
signal jumped
signal stopped_jumping



func _ready():
	pathfinder.register_actor(self)



func setup(new_ring_map:RingMap):
	.setup(new_ring_map)
	
	if not pathfinder:
		pathfinder = $pathfinder
	
	pathfinder.ring_map = ring_map



func interact_with_focus(new_action:String = "") -> bool:
	if focus_target:
		return focus_target.interact(self, new_action)
	
	return false


func move_to(direction:Vector2, sprinting:bool):
	movement_modifier = sprint_modifier if sprinting else 1.0
	
	var move_direction:Vector2 = get_move_direction(direction)
	
	body.move_direction = move_direction
	set_ring_vector(body.ring_vector)
	
	sprite.change_animation(move_direction)
	
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




func set_pathfinding_target(new_target:RingVector):
	pathfinding_target = new_target
	pathfinder.pathfinding_target = pathfinding_target


func set_focus_target(new_target:GameObject):
	focus_target = new_target



func get_pathfinding_target() -> RingVector:
	return pathfinding_target


func get_focus_target() -> GameObject:
	return focus_target


func get_world_position():
	if body:
		return body.global_transform.origin
	else:
		return .get_world_position()
