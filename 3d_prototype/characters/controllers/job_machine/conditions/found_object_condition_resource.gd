class_name FoundObjectConditionResource
extends StateConditionResource

export(Resource) var object_to_look_for

func create_condition() -> StateCondition:
	return FoundObjectCondition.new(object_to_look_for)


class FoundObjectCondition extends StateCondition:
	var _navigation: Navigation
	var _inputs: CharacterMovementInputs
	var _interaction_area: InteractionArea
	
	var _object_resource: ObjectResource
	var _found_item := false
	
	
	func _init(object: ObjectResource) -> void:
		_object_resource = object
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_navigation = character.get_navigation()
		_inputs = Utils.find_node_of_type_in_children(character, CharacterMovementInputs)
		_interaction_area = Utils.find_node_of_type_in_children(character, InteractionArea)
		
		# warning-ignore:return_value_discarded
		_interaction_area.connect("body_entered_perception_area", self, "_check_items")
		# warning-ignore:return_value_discarded
		_interaction_area.connect("body_exited_perception_area", self, "_check_items", [ true ])
		
		_check_items()
	
	
	func _check_items(body: Node = null, body_exited := false) -> void:
		if body_exited:
			return
		
		# warning-ignore-all:unsafe_property_access
		if (body is CollectableItem and body.item_resource == _object_resource) or (body is Structure and body.structure_resource == _object_resource):
			_found_item = true
			return
		
		for object in _interaction_area.objects_in_perception_range:
			if (object is CollectableItem and object.item_resource == _object_resource) or (object is Structure and object.structure_resource == _object_resource):
				_found_item = true
				return
		
		_found_item = false
	
	
	func _statement() -> bool:
		if _found_item:
			_check_items()
			return true
		
		return false
