class_name InputMaster
extends Puppeteer



func get_input(_object_of_interest, hit_box: ActorHitBox, _ring_vector: RingVector, _current_segments: Array, _path_progress: int, actor_behavior: ActorBehavior, animation_tree: AnimationStateMachine) -> Array:
	var commands: Array = [ ]
	
	if Input.is_action_pressed("interact"):
		commands.append(InteractCommand.new(hit_box, actor_behavior.currently_looking_for, animation_tree))
		#get_tree().set_input_as_handled()
	
	var movement_vector: Vector3 = Vector3(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("jump"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands
