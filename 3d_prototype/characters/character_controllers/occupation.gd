class_name Occupation
extends BehaviorTree

export(NodePath) var _character_controller_node
export(NodePath) var _inventory_node

onready var _character_controller: CharacterController = get_node(_character_controller_node)
onready var _inventory: CharacterInventory = get_node(_inventory_node)

var _current_job: Workstation.Job = null


func _ready() -> void:
	var character: Character = owner
	_blackboard = OccupationBlackboard.new(
		self,
		character,
		_character_controller,
		_inventory,
		_current_job,
		character.get_navigation().spotted_items
	)
