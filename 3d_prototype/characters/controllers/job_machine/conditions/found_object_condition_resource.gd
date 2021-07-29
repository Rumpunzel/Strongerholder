class_name FoundObjectConditionResource
extends StateConditionResource

enum ActionType { GATHERS, GATHERS_SOURCE, DELIVERS }

export(ActionType) var _action_type
export(Resource) var _override_object_to_look_for = null

export var _global_range := false
export var _use_spotted_items := true

func create_condition() -> StateCondition:
	return FoundObjectCondition.new(_action_type, _override_object_to_look_for, _global_range, _use_spotted_items)


class FoundObjectCondition extends StateCondition:
	enum ActionType { GATHERS, GATHERS_SOURCE, DELIVERS }
	
	var _spotted_items: SpottedItems
	var _inputs: CharacterMovementInputs
	var _interaction_area: InteractionArea
	
	var _action_type: int
	var _object_to_look_for: ObjectResource
	var _global_range: bool
	var _use_spotted_items: bool
	
	
	func _init(action_type: int, object: ObjectResource, global_range: bool, use_spotted_items: bool) -> void:
		_action_type = action_type
		_object_to_look_for = object
		_global_range = global_range
		_use_spotted_items = use_spotted_items
	
	
	func awake(state_machine: Node) -> void:
		if not _object_to_look_for:
			match _action_type:
				ActionType.GATHERS:
					# warning-ignore:unsafe_property_access
					_object_to_look_for = state_machine.current_job.gathers
				
				ActionType.GATHERS_SOURCE:
					# warning-ignore:unsafe_property_access
					_object_to_look_for = state_machine.current_job.tool_resource.used_on
				
				ActionType.DELIVERS:
					# warning-ignore:unsafe_property_access
					_object_to_look_for = state_machine.current_job.delivers
		
		
		var character: Character = state_machine.owner
		_spotted_items = character.get_navigation().spotted_items
		_inputs = Utils.find_node_of_type_in_children(state_machine, CharacterMovementInputs)
		_interaction_area = Utils.find_node_of_type_in_children(character, InteractionArea)
	
	
	func _check_items() -> bool:
		if _global_range:
			var global_items := _interaction_area.get_tree().get_nodes_in_group(_object_to_look_for.name)
			for item in global_items:
				if not item.has_method("is_dibbable") or item.is_dibbable(_interaction_area):
					return true
		
		if _use_spotted_items:
			if _object_to_look_for is ItemResource:
				var spotted_items := _spotted_items.get_spotted(_object_to_look_for, _interaction_area)
				for item in spotted_items:
					if not item.has_method("is_dibbable") or item.is_dibbable(_interaction_area):
						return true
		
		for percieved_object in _interaction_area.objects_in_perception_range:
			if not percieved_object.has_method("is_dibbable") or percieved_object.is_dibbable(_interaction_area):
				if percieved_object is CollectableItem and percieved_object.item_resource == _object_to_look_for:
					return true
				# HACK: fix this ugly implementation
				elif percieved_object is HitBox and percieved_object.owner is Structure and percieved_object.owner.structure_resource == _object_to_look_for:
					return true
		
		return false
	
	
	func _statement() -> bool:
		return _check_items()
