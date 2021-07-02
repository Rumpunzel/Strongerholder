class_name MoveToPointActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return MoveToPointAction.new()


class MoveToPointAction extends StateAction:
	var _character_controller: CharacterController
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		_character_controller = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character_controller.movement_stats
	
	func on_update(_delta: float) -> void:
		pass
