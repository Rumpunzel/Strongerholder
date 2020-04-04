extends GameObject
class_name GameActor

func is_class(class_type): return class_type == "GameActor" or .is_class(class_type)
func get_class(): return "GameActor"


const INTERACTION = "interaction"
const PARAMETERS = "parameters"


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
		if focus_targets.has(object_of_interest) and object_of_interest.type == currently_searching_for:
			set_currently_searching_for(null)



func setup(new_ring_map:RingMap):
	.setup(new_ring_map)
	
	$pathfinder.ring_map = ring_map



func interaction_with(object:GameObject) -> Dictionary:
	if object:
		var basic_interaction:Dictionary = { INTERACTION: INTERACT_FUNCTION }
		
		match object.type:
			CityLayout.TREE:
				return { INTERACTION: DAMAGE_FUNCTION, PARAMETERS: [ 10.0 ] }
			
			CityLayout.STOCKPILE:
				if not inventory.empty():
					return { INTERACTION: GIVE_FUNCTION, PARAMETERS: [ inventory ] }
			
			_:
				return basic_interaction
	
	return { }



func move_to(direction:Vector2, sprinting:bool):
	movement_modifier = sprint_modifier if sprinting else 1.0
	
	var move_direction:Vector2 = get_move_direction(direction)
	
	body.move_direction = move_direction
	set_ring_vector(body.ring_vector)
	
	sprite.change_animation(move_direction)
	
	emit_signal("moved", ring_vector)


func get_move_direction(direction:Vector2) -> Vector2:
	return cliff_dection.limit_movement(direction) * walkspeed * movement_modifier



func jump():
	body.jump(jump_speed)
	
	emit_signal("jumped")

func stop_jump():
	body.jump()
	
	emit_signal("stopped_jumping")



func add_focus_target(object:GameObject):
	if not focus_targets.has(object):
		focus_targets.append(object)


func erase_focus_target(object:GameObject):
	focus_targets.erase(object)




func set_object_of_interest(new_object:GameObject):
	object_of_interest = new_object


func set_currently_searching_for(new_interest):
	if not new_interest == currently_searching_for:
		currently_searching_for = new_interest
		emit_signal("acquired_target", currently_searching_for)


func set_focus_targets(new_targets:Array):
	focus_targets = new_targets


func set_can_act(new_status:bool):
	can_act = new_status
	
	emit_signal("can_act_again", can_act)



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
