class_name EmployerInteractionResource
extends StateActionResource

func _create_action() -> StateAction:
	return EmployerInteraction.new()


class EmployerInteraction extends StateAction:
	var _employer: Workstation
	var _interaction_area: InteractionArea
	
	func awake(state_machine: Node) -> void:
		_employer = state_machine.current_job.employer
		_interaction_area = Utils.find_node_of_type_in_children(state_machine.owner, InteractionArea)
	
	func on_update(_delta: float) -> void:
		_interaction_area.interact_with_specific_object(_employer)
