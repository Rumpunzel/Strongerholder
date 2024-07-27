class_name OccupationBlackboard
extends Blackboard

var character: CharacterController
var job: Workstation.Job
var spotted_items: SpottedItems

func _init(
	new_behavior_tree_root: BehaviorTree,
	new_character: CharacterController,
	new_job: Workstation.Job,
	new_spotted_items: SpottedItems
).(new_behavior_tree_root) -> void:
	character = new_character
	job = new_job
	spotted_items = new_spotted_items
