class_name LimiterDecorator, "res://editor_tools/class_icons/behavior_tree/icon_limiter.svg"
extends BehaviorTreeDecorator

export var _max_count := 0

var _current_count := 0

func on_update(blackboard: Blackboard) -> int:
	if _current_count >= _max_count:
		return Status.FAILURE
	_current_count += 1
	return _first_child().on_update(blackboard)