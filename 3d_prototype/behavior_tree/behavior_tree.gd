class_name BehaviorTree, "res://editor_tools/class_icons/behavior_tree/icon_tree.svg"
extends Spatial

export var enabled := true setget set_enabled

var _blackboard: Blackboard

onready var _root: BehaviorTreeNode = get_child(0)


func _ready() -> void:
	if not get_child_count() == 1:
		push_error("BehaviorTreeRoot %s should have one child (NodePath: %s)" % [ name, get_path() ])
		enabled = false
	set_enabled(enabled)


func _process(_delta: float) -> void:
	if not _blackboard:
		push_error("BehaviorTreeRoot %s needs a Blackboard (NodePath: %s)" % [ name, get_path() ])
		enabled = false
		return
	var status: int = _root.on_update(_blackboard)
	if not status == BehaviorTreeNode.Status.RUNNING:
		_blackboard.running_action = null


func set_enabled(new_status: bool) -> void:
	enabled = new_status
	set_process(enabled)
