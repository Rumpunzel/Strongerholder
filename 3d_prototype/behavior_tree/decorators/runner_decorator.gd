class_name AlwaysRunDecorator, "res://editor_tools/class_icons/behavior_tree/icon_succeed.svg"
extends BehaviorTreeDecorator

func on_update(blackboard: Blackboard) -> int:
	var child: BehaviorTreeNode = _first_child()
	child.on_update(blackboard)
	if child is ActionLeaf:
		blackboard.running_action = child
	return Status.RUNNING
