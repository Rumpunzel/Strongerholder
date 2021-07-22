class_name EmployerCanBeOperatedConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return EmployerCanBeOperatedCondition.new()


class EmployerCanBeOperatedCondition extends StateCondition:
	var _employer: Workstation
	
	func awake(state_machine: Node) -> void:
		# warning-ignore:unsafe_property_access
		_employer = state_machine.current_job.employer
	
	func _statement() -> bool:
		return _employer.can_be_operated()
