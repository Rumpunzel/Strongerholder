class_name InputMaster
extends Puppeteer



func get_input(_object_of_interest, hit_box: ActorHitBox, _ring_vector: RingVector, _current_segments: Array, _path_progress: int, currently_looking_for: Dictionary) -> Array:
	var commands: Array = [ ]
	
	if Input.is_action_pressed("open_menu"):
		commands.append(MenuCommand.new())
	
	if Input.is_action_pressed("interact"):
		commands.append(InteractCommand.new(hit_box.currently_highlighting, currently_looking_for))
		#get_tree().set_input_as_handled()
	
	var movement_vector: Vector3 = Vector3(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("jump"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands




class MenuCommand extends Puppeteer.Command:
	func execute(actor: ActorHitBox) -> bool:
		actor.open_menu(RadiantUI.new(["Build", "Inspect", "Destroy"], actor))
		return true


class InteractCommand extends Puppeteer.InteractCommand:
	func _init(new_hit_box: ObjectHitBox, new_looking_for: Dictionary).(new_hit_box, new_looking_for):
		pass
	
	func parse(actor: ActorHitBox) -> bool:
		if hit_box.type == Constants.Structures.FOUNDATION:
			actor.open_menu(RadiantUI.new(["Build", "Inspect", "Destroy"], actor.owner))
			return true
		
		return .parse(actor)
