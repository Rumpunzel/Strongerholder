class_name EmployerInteractionResource
extends StateActionResource

export(InteractionArea.InteractionType) var _interaction_type
export(Resource) var _interaction_item

func _create_action() -> StateAction:
	return EmployerInteraction.new(_interaction_type, _interaction_item)


class EmployerInteraction extends StateAction:
	var _employer: Workstation
	var _inventory: CharacterInventory
	var _interaction_area: InteractionArea
	
	var _interaction_type: int
	var _interaction_item: ItemResource
	
	
	func _init(interaction_type: int, interaction_item: ItemResource) -> void:
		_interaction_type = interaction_type
		_interaction_item = interaction_item
	
	
	func awake(state_machine: Node) -> void:
		# warning-ignore:unsafe_property_access
		_employer = state_machine.current_job.employer
		_inventory = Utils.find_node_of_type_in_children(state_machine.owner, CharacterInventory)
		_interaction_area = Utils.find_node_of_type_in_children(state_machine.owner, InteractionArea)
	
	func on_update(_delta: float) -> void:
		var interaction_objects := [ _employer ] if _interaction_area.objects_in_interaction_range.has(_employer) else [ ]
		_interaction_area.interact_with_specific_object(_employer, interaction_objects, _interaction_type, _interaction_item, false)
