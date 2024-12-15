class_name SequenceComposite, "res://editor_tools/class_icons/behavior_tree/icon_sequencer.svg"
extends BehaviorTreeComposite

func on_update(blackboard: Blackboard) -> int:
	for child in get_children():
		var response: int = child.on_update(blackboard)
		if child is ConditionLeaf:
			blackboard.last_condition_entry = Blackboard.ConditionEntry.new(child, response)
		
		if not response == Status.SUCCESS:
			if child is ActionLeaf and response == Status.RUNNING:
				blackboard.running_action = child
			return response
	
	return Status.SUCCESS
