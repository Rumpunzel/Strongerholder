class_name ReadInteractionResource
extends StateActionResource

export(Resource) var _player_interaction_channel
export(Resource) var _player_item_interaction_channel

func _create_action() -> StateAction:
	return ReadInteraction.new(_player_interaction_channel, _player_item_interaction_channel)


class ReadInteraction extends StateAction:
	enum InteractionState { STARTED, CANCELLED, COMPLETED }
	
	var _character: Character
	var _inputs: CharacterMovementInputs
	var _inventory: CharacterInventory
	var _interaction_area: InteractionArea
	
	var _player_interaction_channel: ReferenceEventChannelResource
	var _player_item_interaction_channel: IntEventChannelResource
	
	var _nearest_interaction: InteractionArea.Interaction = null
	var _current_interaction: InteractionArea.Interaction = null
	var _current_interaction_node: Node = null
	
	var _smart_interacting := false
	var _attacking := false
	
	
	func _init(player_interaction_channel: ReferenceEventChannelResource, player_item_interaction_channel: IntEventChannelResource) -> void:
		_player_interaction_channel = player_interaction_channel
		_player_item_interaction_channel = player_item_interaction_channel
	
	
	func awake(state_machine: Node) -> void:
		_character = state_machine.owner
		_inputs = Utils.find_node_of_type_in_children(state_machine, CharacterMovementInputs)
		_inventory = Utils.find_node_of_type_in_children(_character, CharacterInventory)
		_interaction_area = Utils.find_node_of_type_in_children(_character, InteractionArea)
	
	
	func on_state_enter() -> void:
		# warning-ignore:return_value_discarded
		_player_item_interaction_channel.connect("raised", self, "_on_player_item_interaction_completed")
	
	func on_update(_delta: float) -> void:
		if _attacking and _inventory.has_something_equipped():
			_attack_on_spot()
		else:
			_handle_interaction()
	
	func on_state_exit() -> void:
		_player_item_interaction_channel.disconnect("raised", self, "_on_player_item_interaction_completed")
	
	
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
	
	
	func _attack_on_spot() -> void:
		_interaction_area.current_interaction = InteractionArea.Interaction.new(null, InteractionArea.InteractionType.ATTACK)
	
	
	func _handle_interaction() -> void:
		_find_nearest_interaction_for_hud_to_display()
		
		if _smart_interacting and _nearest_interaction:
			_smart_interact()
		elif _current_interaction_node:
			_current_interaction_node = null
			_player_item_interaction_channel.raise(InteractionState.CANCELLED)
		
		if _current_interaction:
			_interaction_area.current_interaction = _current_interaction
	
	
	func _smart_interact() -> void:
		var node := _nearest_interaction.node
		var has_to_wait_for_hud := false
		var interaction_obects := [ node ] if _interaction_area.objects_in_interaction_range.has(node) else [ ]
		
		if node is Stash:
			has_to_wait_for_hud = true
		else:
			_current_interaction = null
		
		if not has_to_wait_for_hud:
			_interaction_area.interact_with_specific_object(node, interaction_obects, _inventory, true)
		else:
			if not _interaction_area.objects_in_interaction_range.has(node):
				_interaction_area.interact_with_specific_object(node, [ ], _inventory, true)
			else:
				_current_interaction_node = node
				_inputs.destination_input = _character.translation
				_player_item_interaction_channel.raise(InteractionState.STARTED)
	
	
	func _find_nearest_interaction_for_hud_to_display() -> void:
		var new_nearest_interaction := _interaction_area.find_nearest_smart_interaction(_interaction_area.objects_in_perception_range, _inventory, true)
		if (not _nearest_interaction or not new_nearest_interaction or not _nearest_interaction.node == new_nearest_interaction.node) and not _nearest_interaction == new_nearest_interaction:
			_nearest_interaction = new_nearest_interaction
			
			if _nearest_interaction:
				var node := _nearest_interaction.node
				if node is Stash:
					if _nearest_interaction.type == InteractionArea.InteractionType.GIVE:
						_player_interaction_channel.raise(_nearest_interaction)
						return
			
			_player_interaction_channel.raise(null)
	
	
	func _on_player_item_interaction_completed(state: int) -> void:
		# TODO: check why this is necessary
		if not weakref(_character).get_ref():
			# warning-ignore:return_value_discarded
			unreference()
			return
		
		if not state == InteractionState.COMPLETED:
			return
		
		var interaction_objects := [ _current_interaction_node ] if _interaction_area.objects_in_interaction_range.has(_current_interaction_node) else [ ]
		_interaction_area.interact_with_specific_object(_current_interaction_node, interaction_objects, _inventory, true)
		_current_interaction = _interaction_area.current_interaction
