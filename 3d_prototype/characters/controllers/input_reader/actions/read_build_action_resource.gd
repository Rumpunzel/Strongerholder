class_name ReadBuildActionResource
extends StateActionResource

# warning-ignore:unused_class_variable
export(Resource) var building_hud_toggled_channel


func _create_action() -> StateAction:
	return ReadBuildAction.new()



class ReadBuildAction extends StateAction:
	var _character: Character
	
	func awake(state_machine: Node) -> void:
		_character = state_machine.owner
	
	func on_input(input: InputEvent) -> void:
		if input.is_action_pressed("open_build_menu"):
			# warning-ignore-all:unsafe_property_access
			origin_resource.building_hud_toggled_channel.raise()
			_character.get_tree().set_input_as_handled()
