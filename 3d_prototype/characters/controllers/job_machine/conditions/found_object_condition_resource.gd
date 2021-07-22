class_name FoundObjectConditionResource
extends StateConditionResource

export(Resource) var _object_to_look_for
export var _global_range := false

func create_condition() -> StateCondition:
	return FoundObjectCondition.new(_object_to_look_for, _global_range)


class FoundObjectCondition extends StateCondition:
	var _navigation: WorldScene
	var _inputs: CharacterMovementInputs
	var _interaction_area: InteractionArea
	
	var _object_resource: ObjectResource
	var _global_range: bool
	
	
	func _init(object: ObjectResource, global_range: bool) -> void:
		_object_resource = object
		_global_range = global_range
	
	
	func awake(state_machine: Node) -> void:
		var character: Character = state_machine.owner
		_navigation = character.get_navigation()
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
				if not item is CollectableItem or not item.called_dibs_by or item.called_dibs_by == _interaction_area:
					return true
		
		elif _object_resource is ItemResource:
			var spotted_items := _navigation.get_spotted(_object_resource)
			for item in spotted_items:
				if not item is CollectableItem or not item.called_dibs_by or item.called_dibs_by == _interaction_area:
					return true
		
		else:
			for percieved_object in _interaction_area.objects_in_perception_range:
				if (percieved_object is CollectableItem and percieved_object.item_resource == _object_resource and (not percieved_object.called_dibs_by or percieved_object.called_dibs_by == _interaction_area)) or (percieved_object is Structure and percieved_object.structure_resource == _object_resource):
					return true
		
		return false
	
	
	func _statement() -> bool:
		return _check_items()
