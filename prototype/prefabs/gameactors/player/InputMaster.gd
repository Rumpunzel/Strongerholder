class_name InputMaster
extends PuppetMaster



func get_input() -> Array:
	var commands: Array = [ ]
	
	if Input.is_action_pressed("interact"):
		commands.append(InteractCommand.new())
		#get_tree().set_input_as_handled()
	
	var movement_vector: Vector3 = Vector3(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("jump"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands




class InteractCommand extends PuppetMaster.InteractCommand:
	func interaction_with(actor: GameActor) -> Dictionary:
		if object:
			match object.type:
				CityLayout.Objects.FOUNDATION:
					var new_menu = RadiantUI.new(["Build", "Inspect", "Destroy"], object, "build_into")
					actor.animation_tree.set("parameters/conditions/outside_menu", false)
					new_menu.connect("closed", actor.animation_tree, "set", ["parameters/conditions/outside_menu", true])
					actor.get_viewport().get_camera().add_ui_element(new_menu)
		
		return .interaction_with(actor)
