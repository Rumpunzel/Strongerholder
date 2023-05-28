class_name SelectorComposite, "res://editor_tools/class_icons/behavior_tree/icon_selector.svg"
extends BehaviorTreeComposite

func on_update(blackboard: Blackboard) -> int:
	for child in get_children():
		var response: int = child.on_update(blackboard)
		if child is ConditionLeaf:
			blackboard.last_condition_entry = Blackboard.ConditionEntry.new(child, response)
		
		if not response == Status.FAILURE:
			if child is ActionLeaf and response == Status.RUNNING:
				blackboard.running_action = child
			return response
	
	return Status.FAILURE
