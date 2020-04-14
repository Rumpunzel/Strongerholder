class_name Puppeteer
extends Resource


func get_input(object_of_interest, current_actor, current_segments: Array, path_progress: int, actor_behavior: ActorBehavior) -> Array:
	var commands: Array = [ ]
	
	if object_of_interest and current_actor.is_in_range(object_of_interest):
		commands.append(InteractCommand.new(object_of_interest))
		actor_behavior.force_search(current_actor.ring_vector)
	
	
	var movement_vector: Vector3 = Vector3()
	var next_path_segment: RingVector = current_segments[path_progress] if path_progress < current_segments.size() else null
	
	if next_path_segment:
		next_path_segment.modulo_ring_vector()
		
		var rotation_change = next_path_segment.rotation - current_actor.ring_vector.rotation
		
		while rotation_change > PI:
			rotation_change -= TAU
		
		while rotation_change < -PI:
			rotation_change += TAU
		
		movement_vector = Vector3(next_path_segment.radius - current_actor.ring_vector.radius, 0, rotation_change)
		
		movement_vector.z *= next_path_segment.radius
		
		#print("movement_vector: %s" % [movement_vector])
	
	commands.append(MoveCommand.new(movement_vector))
	
	return commands




class Command:
	func execute(_actor) -> bool:
		assert(false)
		return false



class MoveCommand extends Command:
	var movement_vector: Vector3
	var sprinting: bool
	
	func _init(new_movement_vector: Vector3, new_sprinting: bool = false):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		#print("%s: %s" % ["actor.name", movement_vector])
		
	func execute(actor) -> bool:
		actor.move_to(movement_vector, sprinting)
		return false



class InteractCommand extends Command:
	const SUBJECT: String = "subject"
	const OBJECT: String = "object"
	const INTERACTION: String = "interaction"
	const PARAMETERS: String = "parameters"
	
	#const BASIC_INTERACTION: Dictionary = { INTERACTION: RingObject.INTERACT_FUNCTION }
	
	
	var other_object
	
	
	func _init(new_object):
		other_object = new_object
	
	
	func execute(actor) -> bool:
		var interaction: Dictionary = interaction_with(actor)
		
		var subject = interaction.get(SUBJECT, actor)
		var object = interaction.get(OBJECT, other_object)
		var function = interaction.get(INTERACTION)
		var parameters: Array = interaction.get(PARAMETERS, [ ])
		
		parameters.append(subject)
		
		if function:
			return object.callv(function, parameters)
		
		return false
	
	
	func interaction_with(actor, interaction: Dictionary = { }, animation: String = "") -> Dictionary:
		if other_object:
			if animation == "":
				if other_object.type == Constants.Structures.TREE:
					animation = "attack"
					#interaction = { INTERACTION: RingObject.DAMAGE_FUNCTION, PARAMETERS: [ 2.0, 0.3 ] }
				elif Constants.is_structure(other_object.type):
					if actor.inventory.empty():
						if not actor.is_looking_for() == Constants.NOTHING:
							animation = "give"
							#interaction = { SUBJECT: other_object, OBJECT: actor, INTERACTION: RingObject.GIVE_FUNCTION, PARAMETERS: [ [ actor.is_looking_for() ] ] }
					else:
						animation = "give"
						#interaction = { INTERACTION: RingObject.GIVE_FUNCTION, PARAMETERS: [ actor.inventory ] }
			
			if animation.length() > 0:
				actor.animate(animation)
			
			return interaction
		
		return { }
