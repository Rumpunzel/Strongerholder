class_name BehaviorTreeDecorator, "res://editor_tools/class_icons/behavior_tree/icon_category_decorator.svg"
extends BehaviorTreeNode

func _ready():
	if not get_child_count() == 1:
		push_error("Decorator %s should have only one child (NodePath: %s)" % [ name, get_path() ])
