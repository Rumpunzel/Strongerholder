class_name EmployerInteractionResource
extends StateActionResource

func _create_action() -> StateAction:
	return EmployerInteraction.new()


class EmployerInteraction extends StateAction:
	var _employer: Workstation
	var _inventory: CharacterInventory
	var _interaction_area: InteractionArea
	
	
	func awake(state_machine: Node) -> void:
		# warning-ignore:unsafe_property_access
		_employer = state_machine.current_job.employer
		_inventory = Utils.find_node_of_type_in_children(state_machine.owner, CharacterInventory)
		_interaction_area = Utils.find_node_of_type_in_children(state_machine.owner, InteractionArea)
	
	func on_update(_delta: float) -> void:
		var interaction_objects := [ _employer ] if _interaction_area.objects_in_interaction_range.has(_employer) else [ ]
		_interaction_area.interact_with_specific_object(_employer, interaction_objects, _inventory, false)
