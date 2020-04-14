class_name InputMaster
extends Puppeteer



func get_input(object_of_interest, _current_actor, _current_segments: Array, _path_progress: int, _actor_behavior: ActorBehavior) -> Array:
	var commands: Array = [ ]
	
	if Input.is_action_pressed("interact"):
		commands.append(InteractCommand.new(object_of_interest))
		#get_tree().set_input_as_handled()
	
	var movement_vector: Vector3 = Vector3(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("jump"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands




class InteractCommand extends Puppeteer.InteractCommand:
	func _init(new_object).(new_object):
		pass
	
	func interaction_with(actor, interaction: Dictionary = { }, animation: String = "") -> Dictionary:
		if other_object:
			if other_object.type == Constants.Structures.FOUNDATION:
				animation = "give"
				
				var new_menu = RadiantUI.new(["Build", "Inspect", "Destroy"], other_object, "build_into")
				actor.can_act = false
				new_menu.connect("closed", actor, "set_can_act", [true])
				actor.get_viewport().get_camera().add_ui_element(new_menu)
		
		return .interaction_with(actor, interaction, animation)
