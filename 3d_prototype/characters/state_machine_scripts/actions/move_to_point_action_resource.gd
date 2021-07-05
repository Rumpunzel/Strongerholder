class_name MoveToPointActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return MoveToPointAction.new()


class MoveToPointAction extends StateAction:
	var _inputs: CharacterMovementInputs
	var _actions: CharacterMovementActions
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_inputs = character.get_inputs()
		_actions = character.get_actions()
		# warning-ignore:unsafe_property_access
		_movement_stats = character.movement_stats
	
	func on_update(_delta: float) -> void:
		_actions.destination_point = _inputs.destination_input
