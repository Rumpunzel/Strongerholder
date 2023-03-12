class_name BehaviorTreeComposite, "res://editor_tools/class_icons/behavior_tree/icon_category_composite.svg"
extends BehaviorTreeNode

func _ready():
	if get_child_count() < 1:
		push_error("Composite %s should have at least one child (NodePath: %s)" % [ name, get_path() ])
