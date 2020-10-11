class_name Puppeteer
extends Resource


func get_input(object_of_interest, hit_box: ActorHitBox, position: Vector2, current_path: PoolVector2Array) -> Array:
	var commands: Array = [ ]
	
	if weakref(object_of_interest).get_ref():
		var hit_box_in_range = hit_box.has_object(object_of_interest)
		
		if not hit_box_in_range and object_of_interest is GameResource and hit_box.has_inactive_object(object_of_interest):
			hit_box_in_range = hit_box.has_object(object_of_interest.get_owner())
		
		if hit_box_in_range:
			commands.append(InteractCommand.new(hit_box_in_range))
	
	
	var movement_vector: Vector2 = Vector2()
	
	if not current_path.empty():
		movement_vector = current_path[0] - position
		#print("movement_vector: %s" % [movement_vector])
		
	commands.append(MoveCommand.new(movement_vector))
	
	return commands




class Command:
	func execute(_actor) -> bool:
		assert(false)
		return false



class MoveCommand extends Command:
	var movement_vector: Vector2
	var sprinting: bool
	
	func _init(new_movement_vector: Vector2, new_sprinting: bool = false):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		
	func execute(actor: GameActor) -> bool:
		actor.move_to(movement_vector, sprinting)
		return false



class InteractCommand extends Command:
	var hit_box: ObjectHitBox
	
	func _init(new_hit_box: ObjectHitBox):
		hit_box = new_hit_box
	
	func execute(actor: ActorHitBox) -> bool:
		if hit_box:
			actor.interact_with(hit_box)
			return true
		else:
			return false
