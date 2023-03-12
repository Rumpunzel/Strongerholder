class_name Occupation
extends BehaviorTreeRoot

export(NodePath) var _character_node
export(NodePath) var _spotted_items_node

onready var _character: Character = get_node(_character_node)
onready var _spotted_items: SpottedItems = get_node(_spotted_items_node)
var _current_job: Workstation.Job = null


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	start(_character, _current_job, _spotted_items)


func start(character: Character, current_job: Workstation.Job, spotted_items: SpottedItems) -> void:
	_character = character
	_current_job = current_job
	_spotted_items = spotted_items
	
	blackboard = OccupationBlackboard.new(
		self,
		_character,
		Utils.find_node_of_type_in_children(_character, CharacterController).blackboard,
		_current_job,
		_spotted_items
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
