class_name FoundObjectConditionResource
extends StateConditionResource

export(Resource) var _object_to_look_for
export var _global_range := false
export var _use_spotted_items := true

func create_condition() -> StateCondition:
	return FoundObjectCondition.new(_object_to_look_for, _global_range, _use_spotted_items)


class FoundObjectCondition extends StateCondition:
	var _spotted_items: SpottedItems
	var _inputs: CharacterMovementInputs
	var _interaction_area: InteractionArea
	
	var _object_resource: ObjectResource
	var _global_range: bool
	var _use_spotted_items: bool
	
	
	func _init(object: ObjectResource, global_range: bool, use_spotted_items: bool) -> void:
		_object_resource = object
		_global_range = global_range
		_use_spotted_items = use_spotted_items
	
	
	func awake(state_machine: Node) -> void:
		var character: Character = state_machine.owner
		_spotted_items = character.get_navigation().spotted_items
		_inputs = Utils.find_node_of_type_in_children(state_machine, CharacterMovementInputs)
		_interaction_area = Utils.find_node_of_type_in_children(character, InteractionArea)
		
		# warning-ignore:return_value_discarded
		#_interaction_area.connect("object_entered_perception_area", self, "_check_items")
		# warning-ignore:return_value_discarded
		#_interaction_area.connect("object_exited_perception_area", self, "_check_items", [ true ])
		
		#_check_items()
	
	
	func _check_items(_object: Node = null, _object_exited := false) -> bool:
#		if object_exited:
#			return
		
		# warning-ignore-all:unsafe_property_access
#		if (object is CollectableItem and object.item_resource == _object_resource) or (object is Structure and object.structure_resource == _object_resource):
#			_found_item = true
#			return
		
		
		if _global_range:
			var global_items := _interaction_area.get_tree().get_nodes_in_group(_object_resource.name)
			for item in global_items:
				if not item.has_method("is_dibbable") or item.is_dibbable(_interaction_area):
					return true
		
		if _use_spotted_items:
			if _object_resource is ItemResource:
				var spotted_items := _spotted_items.get_spotted(_object_resource, _interaction_area)
				for item in spotted_items:
					if not item.has_method("is_dibbable") or item.is_dibbable(_interaction_area):
						return true
		
		for percieved_object in _interaction_area.objects_in_perception_range:
			if not percieved_object.has_method("is_dibbable") or percieved_object.is_dibbable(_interaction_area):
				if percieved_object is CollectableItem and percieved_object.item_resource == _object_resource:
					return true
				# HACK: fix this ugly implementation
				elif percieved_object is HitBox and percieved_object.owner is Structure and percieved_object.owner.structure_resource == _object_resource:
					return true
		
		return false
	
	
	func _statement() -> bool:
		return _check_items()
