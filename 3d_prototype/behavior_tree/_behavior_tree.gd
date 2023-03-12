class_name BehaviorTree
extends Node

enum Status {
	FAILURE = -1,
	SUCCESS,
	RUNNING,
}

class Blackboard:
	# WAITFORUPDATE: specify type after 4.0
	var behavior_tree_root: Node#: BehaviorTreeRoot
	#var running_action: ActionLeaf = null
	var running_action: Node = null
	var last_condition_entry: ConditionEntry = null
	
	func _init(new_behavior_tree_root: Node) -> void:
		behavior_tree_root = new_behavior_tree_root

class ConditionEntry:
	#var condition: ConditionLeaf
	var condition: Node
	var condition_status: int
	
	func _init(new_condition: Node, new_status: int) -> void:
		condition = new_condition
		condition_status = new_status
