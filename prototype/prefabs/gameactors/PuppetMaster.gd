extends Node
class_name PuppetMaster

func is_class(class_type): return class_type == "PuppetMaster" or .is_class(class_type)
func get_class(): return "PuppetMaster"


signal new_commands



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float):
	var commands:Array = get_input()
	
	if not commands.empty():
		emit_signal("new_commands", commands)



func get_input() -> Array:
	assert(false)
	return [ ]




class Command:
	var action_time:float = 0.0
	
	func execute(actor:GameActor) -> bool:
		if actor.can_act:
			if action_time > 0.0:
				actor.set_can_act(false)
				actor.action_timer.start(action_time)
		
		return false


class MoveCommand extends Command:
	var movement_vector:Vector3
	var sprinting:bool
	
	func _init(new_movement_vector:Vector3, new_sprinting:bool):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		
	func execute(actor:GameActor) -> bool:
		if actor.can_act:
			actor.move_to(movement_vector, sprinting)
		else:
			actor.move_to(Vector3(), false)
		
		return false


class InteractCommand extends Command:
	var object:GameObject
	
	func _init(new_object:GameObject = null):
		object = new_object
	
	func execute(actor:GameActor) -> bool:
		if actor.can_act:
			if not object:
				object = actor.object_of_interest
			
			var interaction:Dictionary = actor.interaction_with(object)
			
			var function = interaction.get(GameActor.INTERACTION)
			var parameters:Array = interaction.get(GameActor.PARAMETERS, [ ])
			action_time = interaction.get(GameActor.ACTION_TIME, 0.0)
			
			parameters.append(actor)
			
			if action_time > 0.0:
				actor.set_can_act(false)
				actor.action_timer.start(action_time)
			
			if function:
				return object.callv(function, parameters)
		
		return false
