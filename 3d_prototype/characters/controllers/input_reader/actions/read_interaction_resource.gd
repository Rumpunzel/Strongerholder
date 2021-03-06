class_name ReadInteractionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadInteraction.new()


class ReadInteraction extends StateAction:
	var _character: Character
	var _inputs: CharacterMovementInputs
	var _inventory: CharacterInventory
	var _interaction_area: InteractionArea
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_inputs = _character.get_inputs()
		_inventory = _character.get_inventory()
		_interaction_area = _character.get_interaction_area()
	
	
	func on_update(_delta: float) -> void:
		if Input.is_action_pressed("smart_interact"):
			_interaction_area.interact_with_nearest()
		
		if Input.is_action_just_released("smart_interact"):
			_inputs.destination_input = _character.translation
		
		if Input.is_action_pressed("attack"):
			if _inventory.has_something_equipped():
				_interaction_area.current_interaction = InteractionArea.Interaction.new(null, InteractionArea.InteractionType.ATTACK)
