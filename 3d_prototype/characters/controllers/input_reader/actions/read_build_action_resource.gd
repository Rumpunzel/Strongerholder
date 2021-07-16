class_name ReadBuildActionResource
extends StateActionResource

# warning-ignore:unused_class_variable
export(Resource) var building_hud_toggled_channel
# warning-ignore:unused_class_variable
export(Resource) var building_placement_confirmed_channel
# warning-ignore:unused_class_variable
export(Resource) var building_placement_cancelled_channel

func _create_action() -> StateAction:
	return ReadBuildAction.new()



class ReadBuildAction extends StateAction:
	var _character: Character
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	func on_update(_delta: float) -> void:
		if Input.is_action_just_released("open_build_menu"):
			# warning-ignore-all:unsafe_property_access
			origin_resource.building_hud_toggled_channel.raise()
			_character.get_tree().set_input_as_handled()
		
		if Input.is_action_just_pressed("place_building"):
			# warning-ignore-all:unsafe_property_access
			origin_resource.building_placement_confirmed_channel.raise()
			_character.get_tree().set_input_as_handled()
		
		if Input.is_action_just_released("place_building_cancel"):
			# warning-ignore-all:unsafe_property_access
			origin_resource.building_placement_cancelled_channel.raise()
			_character.get_tree().set_input_as_handled()
