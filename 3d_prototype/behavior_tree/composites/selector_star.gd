class_name SelectorStarComposite, "res://editor_tools/class_icons/behavior_tree/icon_selector_star.svg"
extends BehaviorTreeComposite

var _last_execution_index := 0

func on_update(blackboard: Blackboard) -> int:
	for child in get_children():
		if child.get_index() < _last_execution_index:
			continue
		
		var response = child.on_update(blackboard)
		if child is ConditionLeaf:
			blackboard.last_condition_entry = ConditionEntry.new(child, response)
		
		match response:
			Status.FAILURE:
				_last_execution_index += 1
			Status.SUCCESS:
				_last_execution_index = 0
				return response
			Status.RUNNING:
				if child is ActionLeaf:
					blackboard.running_action = child
				return response
	
	_last_execution_index = 0
	return Status.FAILURE
