class_name ApplyDestinationPointActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ApplyDestinationPointAction.new()


class ApplyDestinationPointAction extends StateAction:
	var _character: Character
	var _navigation: Navigation
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_navigation = _character.navigation
		# warning-ignore:unsafe_property_access
		_movement_stats = _character.movement_stats
	
	func on_update(_delta: float) -> void:
		_character.path = _navigation.get_simple_path(_character.translation, _character.destination_point, true)
		
#		if not horizontal_movement == Vector2.ZERO:
#			var look_position := -Vector3(horizontal_movement.x, 0.0, horizontal_movement.y) * 10.0
#			var new_transform := _character.transform.looking_at(look_position, Vector3.UP)
#			_character.transform  = _character.transform.interpolate_with(new_transform, _movement_stats.turn_rate * delta)
