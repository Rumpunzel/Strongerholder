class_name BehaviorTreeRoot, "res://editor_tools/class_icons/behavior_tree/icon_tree.svg"
extends BehaviorTree

export var enabled := true setget set_enabled

onready var blackboard: Blackboard

onready var _root: BehaviorTreeNode = get_child(0)

func _ready() -> void:
	if not blackboard:
		push_error("BehaviorTreeRoot %s should needs a Blackboard (NodePath: %s)" % [ name, get_path() ])
		enabled = false
	if not get_child_count() == 1:
		push_error("BehaviorTreeRoot %s should have one child (NodePath: %s)" % [ name, get_path() ])
		enabled = false
	set_enabled(enabled)

func _process(_delta: float) -> void:
	var status: int = _root.on_update(blackboard)
	if not status == Status.RUNNING:
		blackboard.running_action = null

func set_enabled(new_status: bool) -> void:
	enabled = new_status
	set_process(enabled)
