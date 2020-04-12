class_name InputMaster
extends PuppetMaster




func _init(new_ring_map: RingMap, new_actor = null).(new_ring_map, new_actor):
	pass





func get_input() -> Array:
	var commands: Array = [ ]
	
	if Input.is_action_pressed("interact"):
		commands.append(InteractCommand.new(object_of_interest))
		get_tree().set_input_as_handled()
	
	var movement_vector: Vector3 = Vector3(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("jump"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands




class InteractCommand extends PuppetMaster.InteractCommand:
	func _init(new_object: GameObject).(new_object):
		pass
	
	func interaction_with(actor, interaction: Dictionary = BASIC_INTERACTION, animation: String = "") -> Dictionary:
		if other_object:
			if other_object.type == Constants.Objects.FOUNDATION:
				animation = "give"
				
				var new_menu = RadiantUI.new(["Build", "Inspect", "Destroy"], other_object, "build_into")
				actor.can_act = false
				new_menu.connect("closed", actor, "set_can_act", [true])
				actor.get_viewport().get_camera().add_ui_element(new_menu)
		
		return .interaction_with(actor, interaction, animation)
