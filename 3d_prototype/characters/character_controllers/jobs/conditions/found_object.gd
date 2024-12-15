extends ConditionLeaf

enum ActionType { GATHERS, GATHERS_SOURCE, DELIVERS }

export(ActionType) var _action_type

export var _use_spotted_items := true


func on_update(blackboard: CharacterBlackboard) -> int:
	var object_to_look_for := _determine_object_to_look_for(blackboard.job)
	var character_controller: CharacterController = blackboard.behavior_tree_root
	
	if _use_spotted_items and _check_spotted_items(object_to_look_for, blackboard):
		return Status.SUCCESS
	
	if _check_perception(object_to_look_for, character_controller):
		return Status.SUCCESS
	
	return Status.FAILURE


func _determine_object_to_look_for(job: Workstation.Job) -> ObjectResource:
	match _action_type:
		ActionType.GATHERS:
			# warning-ignore:unsafe_property_access
			return job.gathers
		
		ActionType.GATHERS_SOURCE:
			# warning-ignore:unsafe_property_access
			return job.tool_resource.used_on
		
		ActionType.DELIVERS:
			# warning-ignore:unsafe_property_access
			return job.delivers
	
	return null


func _check_spotted_items(object_to_look_for: ObjectResource, blackboard: CharacterBlackboard) -> bool:
	if not object_to_look_for is ItemResource:
		return false
	var spotted_items := blackboard.spotted_items.get_spotted(object_to_look_for, blackboard.behavior_tree_root)
	for item in spotted_items:
		if not item.has_method("is_dibbable") or item.is_dibbable(blackboard.behavior_tree_root):
			return true
	return false

func _check_perception(object_to_look_for: ObjectResource, character_controller: CharacterController) -> bool:
	for percieved_object in character_controller.perception_area.objects_in_perception_range:
		if not percieved_object.has_method("is_dibbable") or percieved_object.is_dibbable(character_controller):
			if percieved_object is CollectableItem and percieved_object.item_resource == object_to_look_for:
				return true
			# HACK: fix this ugly implementation
			elif percieved_object is HitBox and percieved_object.owner is Structure and percieved_object.owner.structure_resource == object_to_look_for:
				return true
	return false
