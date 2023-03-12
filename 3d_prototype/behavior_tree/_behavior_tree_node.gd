class_name BehaviorTreeNode
extends BehaviorTree

# WAITFORUPDATE: specify type after 4.0
func on_update(blackboard) -> int:#: Blackboard) -> int:
	return Status.SUCCESS

# WAITFORUPDATE: specify type after 4.0
func _first_child():# -> BehaviorTreeNode:
	return get_child(0) as BehaviorTreeNode
