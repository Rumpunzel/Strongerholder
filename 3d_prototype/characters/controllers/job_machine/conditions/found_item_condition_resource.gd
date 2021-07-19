class_name FoundItemConditionResource
extends StateConditionResource

export(Resource) var item_to_look_for

func create_condition() -> StateCondition:
	return FoundItemCondition.new(item_to_look_for)


class FoundItemCondition extends StateCondition:
	var _navigation: Navigation
	var _inputs: CharacterMovementInputs
	var _interaction_area: InteractionArea
	
	var _item_resource: ItemResource
	var _found_item := false
	
	
	func _init(item: ItemResource) -> void:
		_item_resource = item
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_navigation = character.get_navigation()
		_inputs = character.get_inputs()
		_interaction_area = character.get_interaction_area()
		
		# warning-ignore:return_value_discarded
		_interaction_area.connect("body_entered_perception_area", self, "_check_items")
		# warning-ignore:return_value_discarded
		_interaction_area.connect("body_exited_perception_area", self, "_check_items", [ true ])
		
		_check_items()
	
	
	func _check_items(body: Node = null, body_exited := false) -> void:
		# warning-ignore:unsafe_property_access
		if not body_exited and body is CollectableItem and body.item_resource == _item_resource:
			_found_item = true
			return
		
		for item in _interaction_area.objects_in_perception_range:
			if item is CollectableItem and item.item_resource == _item_resource:
				_found_item = true
				return
		
		_found_item = false
	
	
	func _statement() -> bool:
		return _found_item
