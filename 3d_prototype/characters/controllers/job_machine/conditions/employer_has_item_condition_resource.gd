class_name EmployerHasItemConditionResource
extends StateConditionResource

enum ActionType { GATHERS, DELIVERS }

export(ActionType) var _action_type
export(Resource) var _override_interaction_item = null

func create_condition() -> StateCondition:
	return InventoryHasItemCondition.new(_action_type, _override_interaction_item)


class InventoryHasItemCondition extends StateCondition:
	enum ActionType { GATHERS, DELIVERS }
	
	var _employer: Workstation
	var _action_type: int
	var _interaction_item: ItemResource
	
	
	func _init(action_type: int, item: ItemResource) -> void:
		_action_type = action_type
		_interaction_item = item
	
	
	func awake(state_machine: Node) -> void:
		# warning-ignore:unsafe_property_access
		_employer = state_machine.current_job.employer
		
		if not _interaction_item:
			match _action_type:
				ActionType.GATHERS:
					# warning-ignore:unsafe_property_access
					_interaction_item = state_machine.current_job.gathers
				
				ActionType.DELIVERS:
					# warning-ignore:unsafe_property_access
					_interaction_item = state_machine.current_job.delivers
	
	
	func _statement() -> bool:
		return _employer.contains(_interaction_item) != null
