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
onready var action_timer:Timer = $action_timer

onready var behavior = actor_behavior.new()


var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for

var can_act:bool = true setget set_can_act, get_can_act

var current_action:String = ""


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
				return { INTERACTION: DAMAGE_FUNCTION, PARAMETERS: [ 2.0, 0.3 ], ACTION_TIME: 0.7 }
			
			CityLayout.STOCKPILE:
				if not inventory.empty():
					current_action = "death"
					return { INTERACTION: GIVE_FUNCTION, PARAMETERS: [ inventory ], ACTION_TIME: 1.0 }
			
			_:
				return basic_interaction
	
	return { }



func move_to(direction:Vector3, sprinting:bool):
	body.sprinting = sprinting
	body.move_direction = direction
	
	.set_ring_vector(body.ring_vector)
	
	sprite.change_animation(Vector2(body.move_direction.x, body.move_direction.z), current_action)



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
