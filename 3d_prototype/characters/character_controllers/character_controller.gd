class_name Occupation
extends BehaviorTreeRoot

export(NodePath) var _character_controller_node

onready var _character_controller: CharacterController = get_node(_character_controller_node)

var _current_job: Workstation.Job = null


func _ready() -> void:
	var character: Character = owner
	blackboard = OccupationBlackboard.new(
		self,
		character,
		_character_controller.blackboard,
		_current_job,
		character.get_navigation().spotted_items
	)
	
	set_enabled(true)



class OccupationBlackboard extends BehaviorTree.Blackboard:
	var character: Character
	var character_blackboard: CharacterController.Blackboard
	var job: Workstation.Job
	var spotted_items: SpottedItems
	
	func _init(
		new_behavior_tree_root: BehaviorTreeRoot,
		new_character: Character,
		new_character_blackboard: CharacterController.Blackboard,
		new_job: Workstation.Job,
		new_spotted_items: SpottedItems
	).(new_behavior_tree_root) -> void:
		character = new_character
		character_blackboard = new_character_blackboard
		job = new_job
		spotted_items = new_spotted_items
