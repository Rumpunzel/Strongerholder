class_name EmployerCouldBeOperatedConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return EmployerCouldBeOperatedCondition.new()


class EmployerCouldBeOperatedCondition extends StateCondition:
	var _inventory: Inventory
	var _employer: Workstation
	
	func awake(state_machine: Node) -> void:
		var character: Character = state_machine.owner
		_inventory = Utils.find_node_of_type_in_children(character, Inventory)
		# warning-ignore:unsafe_property_access
		_employer = state_machine.current_job.employer
	
	func _statement() -> bool:
		return _employer.could_be_operated(_inventory)
