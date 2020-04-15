class_name Puppeteer
extends Resource


func get_input(object_of_interest, hit_box: ActorHitBox, ring_vector: RingVector, current_segments: Array, path_progress: int, actor_behavior: ActorBehavior) -> Array:
	var commands: Array = [ ]
	var hit_box_in_range = hit_box.has_object(object_of_interest)
	
	if object_of_interest and hit_box_in_range:
		commands.append(InteractCommand.new(hit_box_in_range, actor_behavior.currently_looking_for))
		actor_behavior.force_search(ring_vector)
	
	
	var movement_vector: Vector3 = Vector3()
	var next_path_segment: RingVector = current_segments[path_progress] if path_progress < current_segments.size() else null
	
	if next_path_segment:
		next_path_segment.modulo_ring_vector()
		
		var rotation_change = next_path_segment.rotation - ring_vector.rotation
		
		while rotation_change > PI:
			rotation_change -= TAU
		
		while rotation_change < -PI:
			rotation_change += TAU
		
		movement_vector = Vector3(next_path_segment.radius - ring_vector.radius, 0, rotation_change)
		
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
		
	func execute(actor) -> bool:
		actor.move_to(movement_vector, sprinting)
		return false



class InteractCommand extends Command:
	var hit_box
	var looking_for
	
	func _init(new_hit_box, new_looking_for):
		hit_box = new_hit_box
		looking_for = new_looking_for
	
	func execute(actor) -> bool:
		if hit_box:
			return parse(actor)
		else:
			return false
	
	func parse(actor) -> bool:
		if hit_box.type == Constants.Structures.TREE:
			actor.attack(hit_box)
			return true
		elif Constants.is_structure(hit_box.type):
			if looking_for == Constants.Resources.NOTHING:
				actor.offer_item(looking_for, hit_box)
				return true
			else:
				actor.request_item(looking_for, hit_box)
				return true
		
		return false
