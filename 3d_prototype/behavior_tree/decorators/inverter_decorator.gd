class_name InverterDecorator, "res://editor_tools/class_icons/behavior_tree/icon_inverter.svg"
extends BehaviorTreeDecorator

func on_update(blackboard: Blackboard) -> int:
	var child: BehaviorTreeNode = _first_child()
	var response = child.on_update(blackboard)
	if response == Status.SUCCESS:
		return Status.FAILURE
	if response == Status.FAILURE:
		return Status.SUCCESS
	
	if child is BehaviorTreeLeaf:
		blackboard.running_action = child
	return Status.RUNNING
