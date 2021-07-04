class_name MoveToPointActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return MoveToPointAction.new()


class MoveToPointAction extends StateAction:
	var _character: Character
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character.movement_stats
	
	func on_update(_delta: float) -> void:
		_character.destination_point = _character.destination_input
