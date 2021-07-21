class_name ReadInteractionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadInteraction.new()


class ReadInteraction extends StateAction:
	var _character: Character
	var _inputs: CharacterMovementInputs
	var _inventory: CharacterInventory
	var _interaction_area: InteractionArea
	
	var _smart_interacting := false
	var _attacking := false
	
	
	func awake(state_machine: Node) -> void:
		_character = state_machine.owner
		_inputs = Utils.find_node_of_type_in_children(state_machine, CharacterMovementInputs)
		_inventory = Utils.find_node_of_type_in_children(_character, CharacterInventory)
		_interaction_area = Utils.find_node_of_type_in_children(_character, InteractionArea)
	
	
	func on_update(_delta: float) -> void:
		if _smart_interacting:
			_interaction_area.smart_interact_with_nearest(_inventory)
		
		if _attacking and _inventory.has_something_equipped():
			_interaction_area.current_interaction = InteractionArea.Interaction.new(null, InteractionArea.InteractionType.ATTACK)
	
	
	func on_input(input: InputEvent) -> void:
		if input.is_action_pressed("smart_interact"):
			_smart_interacting = true
			_character.get_tree().set_input_as_handled()
		elif input.is_action_released("smart_interact"):
			_smart_interacting = false
			_inputs.destination_input = _character.translation
			_character.get_tree().set_input_as_handled()
		
		if input.is_action_pressed("attack"):
			_attacking = true
			_character.get_tree().set_input_as_handled()
		elif input.is_action_released("attack"):
			_attacking = false
			_character.get_tree().set_input_as_handled()
