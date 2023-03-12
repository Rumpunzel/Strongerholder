class_name BehaviorTreeRoot, "res://editor_tools/class_icons/behavior_tree/icon_tree.svg"
extends BehaviorTree

export var enabled := true setget set_enabled

# WAITFORUPDATE: specify type after 4.0
onready var blackboard: Blackboard = _create_blackboard()

onready var _root: BehaviorTreeNode = get_child(0)

func _ready() -> void:
	if not get_child_count() == 1:
		push_error("BehaviorTreeRoot %s should have one child (NodePath: %s)" % [ name, get_path() ])
		enabled = false

func _process(_delta: float) -> void:
	var status: int = _root.on_update(blackboard)
	if not status == Status.RUNNING:
		blackboard.running_action = null

func set_enabled(new_status: bool) -> void:
	enabled = new_status
	set_process(enabled)

# WAITFORUPDATE: specify type after 4.0
func _create_blackboard():# -> BehaviorTreeNode.Blackboard:
	return Blackboard.new(self)
