class_name AlwaysFailDecorator, "res://editor_tools/class_icons/behavior_tree/icon_fail.svg"
extends BehaviorTreeDecorator

func on_update(_blackboard: Blackboard) -> int:
	if _first_child().on_update(blackboard) == Status.RUNNING:
		return Status.RUNNING
	return Status.FAILURE
