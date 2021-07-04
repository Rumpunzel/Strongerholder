class_name StopMovementActionResource
extends StateActionResource

export(StateAction.SpecificMoment) var _moment = StateAction.SpecificMoment.ON_STATE_ENTER

func _create_action() -> StateAction:
	return StopMovementAction.new(_moment)


class StopMovementAction extends StateAction:
	var _character: Character
	var _moment: int
	
	
	func _init(moment: int):
		_moment = moment
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	func on_state_enter() -> void:
		if _moment == StateAction.SpecificMoment.ON_STATE_ENTER:
			_null_movement()
	
	func on_update(_delta: float) -> void:
		if _moment == StateAction.SpecificMoment.ON_UPDATE:
			_null_movement()
	
	func on_state_exit() -> void:
		if _moment == StateAction.SpecificMoment.ON_STATE_EXIT:
			_null_movement()
	
	
	func _null_movement() -> void:
		_character.destination_input = _character.translation
		_character.horizontal_movement_vector = Vector2.ZERO
