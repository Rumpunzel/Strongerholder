class_name Blackboard

# WAITFORUPDATE: specify type after 4.0
var behavior_tree: Spatial#: BehaviorTreeRoot

#var running_action: ActionLeaf = null
var running_action: Node = null
var last_condition_entry: ConditionEntry = null

func _init(new_behavior_tree: Spatial) -> void:
	behavior_tree = new_behavior_tree


class ConditionEntry:
	#var condition: ConditionLeaf
	var condition: Node
	var condition_status: int

	func _init(new_condition: Node, new_status: int) -> void:
		condition = new_condition
		condition_status = new_status
