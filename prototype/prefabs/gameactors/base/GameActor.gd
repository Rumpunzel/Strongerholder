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


# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var movement_modifier:float = 1.0

var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for
#var focus_targets:Array = [ ] setget set_focus_targets, get_focus_targets

var can_act:bool = true setget set_can_act, get_can_act


signal moved
signal new_interest
signal acquired_target
signal can_act_again




func _ready():
	action_timer.connect("timeout", self, "set_can_act", [true])
	
	$pathfinder.register_actor(self)




func setup(new_ring_map:RingMap):
	.setup(new_ring_map)
	
	$pathfinder.ring_map = ring_map



func listen_to_commands(new_commands):
	for command in new_commands:
		if command.execute(self):
			break



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



func move_to(direction:Vector3, sprinting:bool):
	movement_modifier = sprint_modifier if sprinting else 1.0
	
	var move_direction:Vector3 = get_move_direction(direction)
	
	body.move_direction = move_direction
	set_ring_vector(body.ring_vector)
	
	sprite.change_animation(Vector2(move_direction.x, move_direction.z))
	
	emit_signal("moved", ring_vector)


func get_move_direction(direction:Vector3) -> Vector3:
	var move_direction = cliff_dection.limit_movement(direction)
	move_direction.y = 0
	move_direction = move_direction.normalized()
	move_direction.y = direction.y
	
	return move_direction * walkspeed * movement_modifier




func set_object_of_interest(new_object:GameObject):
	if not new_object == object_of_interest:
		object_of_interest = new_object
		emit_signal("new_interest", object_of_interest)


func set_currently_searching_for(new_interest):
	if not new_interest == currently_searching_for:
		currently_searching_for = new_interest
		emit_signal("acquired_target", currently_searching_for)


func set_can_act(new_status:bool):
	can_act = new_status
	emit_signal("can_act_again", can_act)



func get_object_of_interest() -> GameObject:
	return object_of_interest


func get_currently_searching_for():
	return currently_searching_for


func get_can_act() -> bool:
	return can_act
