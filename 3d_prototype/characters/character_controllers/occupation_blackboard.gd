class_name OccupationBlackboard
extends Blackboard

signal current_target_changed(target)

var character: Character
var character_controller: CharacterController
var interaction_area: ObjectTrackingArea
var inventory: Inventory
var job: Workstation.Job
var spotted_items: SpottedItems

var current_target: CharacterController.Target = null setget set_current_target


func _init(
	new_behavior_tree_root: BehaviorTree,
	new_character: Character,
	new_character_controller: CharacterController,
	new_interaction_area: ObjectTrackingArea,
	new_inventory: Inventory,
	new_job: Workstation.Job,
	new_spotted_items: SpottedItems
).(new_behavior_tree_root) -> void:
	character = new_character
	character_controller = new_character_controller
	interaction_area = new_interaction_area
	inventory = new_inventory
	job = new_job
	spotted_items = new_spotted_items


func reset() -> void:
	set_current_target(null)


func nearest_percieved_target(overwrite_dibs: bool = false) -> CharacterController.Target:
	return behavior_tree.nearest_interactable_target(overwrite_dibs)


func set_current_target(new_target: CharacterController.Target) -> void:
	if current_target == new_target:
		return
	
	if current_target:
		CharacterBlackboard.undib_node(current_target.node, character)
	
	current_target = new_target
	emit_signal("current_target_changed", current_target)
	
	if current_target:
		CharacterBlackboard.dib_node(current_target.node, character)
