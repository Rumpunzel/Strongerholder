extends Node
class_name PuppetMaster

func is_class(class_type): return class_type == "PuppetMaster" or .is_class(class_type)
func get_class(): return "PuppetMaster"


var current_actor:GameActor = null setget set_current_actor, get_current_actor



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float):
	if current_actor:
		var commands:Array = get_input()
		
		for command in commands:
			if command.execute(current_actor):
				break



func get_input() -> Array:
	assert(false)
	return [ ]


func register_actor(new_actor:GameActor):
	set_current_actor(new_actor)


func remove_actor(old_actor):
	if old_actor == current_actor:
		set_current_actor(null)
		
#		for con_signal in connected_signals:
#			con_signal.disconnect()



func set_current_actor(new_actor:GameActor):
	current_actor = new_actor



func get_current_actor() -> GameActor:
	return current_actor




class Command:
	var action_time:float = 0.0
	
	func execute(actor:GameActor) -> bool:
		if actor.can_act:
			if action_time > 0.0:
				actor.set_can_act(false)
				actor.action_timer.start(action_time)
		
		return false


class MoveCommand extends Command:
	var movement_vector:Vector2
	var sprinting:bool
	
	func _init(new_movement_vector:Vector2, new_sprinting:bool):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		
	func execute(actor:GameActor) -> bool:
		if actor.can_act:
			actor.move_to(movement_vector, sprinting)
		else:
			actor.move_to(Vector2(), false)
		
		return false


class JumpCommand extends Command:
	func execute(actor:GameActor) -> bool:
		if actor.can_act:
			actor.jump()
		
		return false


class InteractCommand extends Command:
	var object:GameObject
	
	func _init(new_object:GameObject = null, new_action_time:float = 0.0):
		object = new_object
		action_time = new_action_time
	
	func execute(actor:GameActor) -> bool:
		if actor.can_act:
			if action_time > 0.0:
				actor.set_can_act(false)
				actor.action_timer.start(action_time)
				
				yield(actor, "can_act_again")
			
			if not object:
				object = actor.object_of_interest
			
			var interaction:Dictionary = actor.interaction_with(object)
			
			var function = interaction.get(GameActor.INTERACTION)
			var parameters:Array = interaction.get(GameActor.PARAMETERS, [ ])
			
			parameters.append(actor)
			
			if function:
				return object.callv(function, parameters)
		
		return false
