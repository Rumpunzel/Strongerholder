class_name EmployerHasItemConditionResource
extends StateConditionResource

export(Resource) var _item = null

func create_condition() -> StateCondition:
	return InventoryHasItemCondition.new(_item)


class InventoryHasItemCondition extends StateCondition:
	var _employer: Workstation
	var _item_resource: ItemResource
	
	func _init(item: ItemResource) -> void:
		_item_resource = item
	
	func awake(state_machine: Node) -> void:
		# warning-ignore:unsafe_property_access
		_employer = state_machine.current_job.employer
	
	func _statement() -> bool:
		return not _employer.contains(_item_resource) == null
