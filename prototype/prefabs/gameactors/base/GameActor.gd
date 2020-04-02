extends GameObject
class_name GameActor

func is_class(type): return type == "GameActor" or .is_class(type)
func get_class(): return "GameActor"


onready var body:KinematicBody = $body
onready var sprite:Sprite3D = $body/sprite
onready var cliff_dection = $body/cliff_detection
onready var action_timer:Timer = $action_timer


export var walkspeed:float = 3.0
export var sprint_modifier:float = 2.5
export var jump_speed:float = 30.0


# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var movement_modifier:float = 1.0

var pathfinding_target:RingVector setget set_pathfinding_target, get_pathfinding_target

var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for
var focus_targets:Array = [ ] setget set_focus_targets, get_focus_targets

var can_act:bool = true setget set_can_act, get_can_act


signal moved
signal jumped
signal stopped_jumping
signal acquired_target
signal can_act_again



func _ready():
	action_timer.connect("timeout", self, "set_can_act", [true])
	
	$pathfinder.register_actor(self)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if object_of_interest:
		if focus_targets.has(object_of_interest):
			set_currently_searching_for(null)



func setup(new_ring_map:RingMap):
	.setup(new_ring_map)
	
	$pathfinder.ring_map = ring_map



func interact_with_object(object:GameObject = object_of_interest) -> bool:
	if object:
		return object.interact("", self)
	else:
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


func set_object_of_interest(new_object:GameObject):
	object_of_interest = new_object


func set_currently_searching_for(new_interest):
	currently_searching_for = new_interest
	emit_signal("acquired_target", currently_searching_for)


func set_focus_targets(new_targets:Array):
	focus_targets = new_targets


func set_can_act(new_status:bool):
	can_act = new_status
	
	emit_signal("can_act_again", can_act)



func get_pathfinding_target() -> RingVector:
	return pathfinding_target


func get_object_of_interest() -> GameObject:
	return object_of_interest


func get_currently_searching_for():
	return currently_searching_for


func get_focus_targets() -> Array:
	return focus_targets


func get_can_act() -> bool:
	return can_act


func get_world_position():
	if body:
		return body.global_transform.origin
	else:
		return .get_world_position()
