class_name AlwaysSucceedDecorator, "res://editor_tools/class_icons/behavior_tree/icon_succeed.svg"
extends BehaviorTreeDecorator

func on_update(blackboard: Blackboard) -> int:
	if _first_child().on_update(blackboard) == Status.RUNNING:
		return Status.RUNNING
	return Status.SUCCESS
