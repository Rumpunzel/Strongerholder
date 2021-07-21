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
	
	func on_enter_state() -> void:
		_interaction_area._nearest_interaction = InteractionArea.Interaction.new(_employer, InteractionArea.InteractionType.GIVE)
	
	func on_update(_delta: float) -> void:
		_interaction_area._nearest_interaction = InteractionArea.Interaction.new(_employer, InteractionArea.InteractionType.GIVE)
		_interaction_area.smart_interact_with_nearest()
