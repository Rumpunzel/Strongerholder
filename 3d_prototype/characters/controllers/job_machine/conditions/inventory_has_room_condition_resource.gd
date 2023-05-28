class_name InventoryHasRoomConditionResource
extends StateConditionResource

enum ActionType { GATHERS, DELIVERS }

export(ActionType) var _action_type
export(Resource) var _override_item = null

func create_condition() -> StateCondition:
	return InventoryHasRoomCondition.new(_action_type, _override_item)


class InventoryHasRoomCondition extends StateCondition:
	enum ActionType { GATHERS, DELIVERS }
	
	var _inventory: Inventory
	var _action_type: int
	var _item_resource: ItemResource
	
	
	func _init(action_type: int, item: ItemResource) -> void:
		_action_type = action_type
		_item_resource = item
	
	
	func awake(state_machine: Node) -> void:
		if not _item_resource:
			match _action_type:
				ActionType.GATHERS:
					# warning-ignore:unsafe_property_access
					_item_resource = state_machine.current_job.gathers
				
				ActionType.DELIVERS:
					# warning-ignore:unsafe_property_access
					_item_resource = state_machine.current_job.delivers
		
		var character: Character = state_machine.owner
		_inventory = Utils.find_node_of_type_in_children(character, Inventory)
	
	
	func _statement() -> bool:
		return not _inventory.full(_item_resource)
