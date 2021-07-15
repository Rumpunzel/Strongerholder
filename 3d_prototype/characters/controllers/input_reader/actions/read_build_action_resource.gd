class_name ReadBuildActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadBuildAction.new()


class ReadBuildAction extends StateAction:
	var _character: Character
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	
	func on_update(_delta: float) -> void:
		if Input.is_action_just_released("open_build_menu"):
			Events.hud.emit_signal("building_hud_toggled")
			_character.get_tree().set_input_as_handled()
		
		if Input.is_action_just_pressed("place_building"):
			Events.gameplay.emit_signal("building_placement_confirmed")
			_character.get_tree().set_input_as_handled()
		
		if Input.is_action_just_released("place_building_cancel"):
			Events.gameplay.emit_signal("building_placement_cancelled")
			_character.get_tree().set_input_as_handled()
