class_name ToggleMovementActionResource
extends StateActionResource

enum MovementType { CONTINUOUS, NAVIGATION }

export(MovementType) var _movement_type = MovementType.CONTINUOUS


func _create_action() -> StateAction:
	return ToggleMovementAction.new(_movement_type)



class ToggleMovementAction extends StateAction:
	enum { CONTINUOUS, NAVIGATION }
	
	var _character: Character
	var _inputs: CharacterMovementInputs
	var _actions: CharacterMovementActions
	var _movement_type: int
	
	
	func _init(movement_type: int):
		_movement_type = movement_type
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_inputs = _character.get_inputs()
		_actions = _character.get_actions()
	
	
	func on_state_enter() -> void:
		match _movement_type:
			CONTINUOUS:
				_actions.moving_to_destination = false
			NAVIGATION:
				_actions.moving_to_destination = true
	
	func on_update(_delta: float) -> void:
		match _movement_type:
			CONTINUOUS:
				_inputs.destination_input = _character.translation
