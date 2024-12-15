class_name SequenceOnceComposite, "res://editor_tools/class_icons/behavior_tree/icon_sequencer_star.svg"
extends BehaviorTreeComposite

var _successful_index := 0

func on_update(blackboard: Blackboard) -> int:
	for child in get_children():
		if child.get_index() < _successful_index:
			continue
		
		var response: int = child.on_update(blackboard)
		if child is ConditionLeaf:
			blackboard.last_condition_entry = Blackboard.ConditionEntry.new(child, response)
		
		match response:
			Status.FAILURE:
				_successful_index = 0
				return response
			Status.SUCCESS:
				_successful_index += 1
			Status.RUNNING:
				if child is ActionLeaf:
					blackboard.running_action = child
					return response
		
	if _successful_index == get_child_count():
		_successful_index = 0
		return Status.SUCCESS
	
	_successful_index = 0
	return Status.FAILURE
