extends GameObject
class_name GameActor

func is_class(class_type): return class_type == "GameActor" or .is_class(class_type)
func get_class(): return "GameActor"


const INTERACTION = "interaction"
const PARAMETERS = "parameters"
const ACTION_TIME = "action_time"


export(GDScript) var actor_behavior


onready var body:KinematicBody = $body
onready var sprite:Sprite3D = $body/sprite
onready var cliff_dection = $body/cliff_detection
onready var action_timer:Timer = $action_timer

onready var behavior = actor_behavior.new()


export var walkspeed:float = 5.0
export var sprint_modifier:float = 2.0


# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var movement_modifier:float = 1.0

var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for

var can_act:bool = true setget set_can_act, get_can_act

var current_action:String = ""


signal moved
signal new_interest
signal acquired_target
signal can_act_again




func _ready():
	connect("can_act_again", self, "acquire_new_target")
	action_timer.connect("timeout", self, "set_can_act", [true])
	
	$pathfinder.register_actor(self)
	
	acquire_new_target()




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
				current_action = "attack"
				return { INTERACTION: DAMAGE_FUNCTION, PARAMETERS: [ 1.0, 0.3 ], ACTION_TIME: 0.7 }
			
			CityLayout.STOCKPILE:
				if not inventory.empty():
					return { INTERACTION: GIVE_FUNCTION, PARAMETERS: [ inventory ], ACTION_TIME: 0.2 }
			
			_:
				return basic_interaction
	
	return { }



func move_to(direction:Vector3, sprinting:bool):
	movement_modifier = sprint_modifier if sprinting else 1.0
	
	var move_direction:Vector3 = get_move_direction(direction)
	
	body.move_direction = move_direction
	.set_ring_vector(body.ring_vector)
	
	sprite.change_animation(Vector2(move_direction.x, move_direction.z), current_action)
	
	emit_signal("moved", ring_vector)


func get_move_direction(direction:Vector3) -> Vector3:
	var move_direction = cliff_dection.limit_movement(direction)
	move_direction.y = 0
	move_direction = move_direction.normalized() * walkspeed * movement_modifier
	move_direction.y = direction.y
	
	return move_direction



func acquire_new_target(searching:bool = true):
	if searching:
		set_currently_searching_for(behavior.next_priority(inventory))




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
	
	if can_act:
		current_action = ""
		sprite.change_animation(Vector2(), current_action)
	
	emit_signal("can_act_again", can_act)


func set_ring_vector(new_vector:RingVector):
	$body.ring_vector = new_vector
	.set_ring_vector($body.ring_vector)



func get_object_of_interest() -> GameObject:
	return object_of_interest

func get_currently_searching_for():
	return currently_searching_for

func get_can_act() -> bool:
	return can_act

func get_ring_vector() -> RingVector:
	return $body.ring_vector
