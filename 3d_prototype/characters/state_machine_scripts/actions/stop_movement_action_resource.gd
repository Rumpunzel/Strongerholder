class_name StopMovementActionResource
extends StateActionResource

export(StateAction.SpecificMoment) var _moment = StateAction.SpecificMoment.ON_STATE_ENTER

func _create_action() -> StateAction:
	return StopMovementAction.new(_moment)


class StopMovementAction extends StateAction:
	var _character: Character
	var _inputs: CharacterMovementInputs
	var _actions: CharacterMovementActions
	var _interaction_area: InteractionArea
	
	var _moment: int
	
	
	func _init(moment: int):
		_moment = moment
	
	
	func awake(state_machine: Node) -> void:
		_character = state_machine.owner
		_inputs = Utils.find_node_of_type_in_children(_character, CharacterMovementInputs, true)
		_actions = Utils.find_node_of_type_in_children(_character, CharacterMovementActions, true)
		_interaction_area = Utils.find_node_of_type_in_children(_character, InteractionArea)
	
	func on_state_enter() -> void:
		if _moment != StateAction.SpecificMoment.ON_STATE_EXIT:
			_null_movement()
	
	func on_update(_delta: float) -> void:
		if _moment == StateAction.SpecificMoment.ON_UPDATE:
			_null_movement()
	
	func on_state_exit() -> void:
		if _moment != StateAction.SpecificMoment.ON_STATE_ENTER:
			_null_movement()
	
	
	func _null_movement() -> void:
		_inputs.destination_input = _character.translation
		_actions.horizontal_movement_vector = Vector2.ZERO
		_interaction_area.reset()
		
		var new_movement_vector := Vector3(0.0, _actions.vertical_velocity, 0.0)
		_character.velocity = new_movement_vector
