class_name InventoryHasRoomConditionResource
extends StateConditionResource

export(Resource) var room_for_item = null

func create_condition() -> StateCondition:
	return InventoryHasRoomCondition.new(room_for_item)


class InventoryHasRoomCondition extends StateCondition:
	var _inventory: CharacterInventory
	var _item_resource: ItemResource
	
	func _init(item: ItemResource) -> void:
		_item_resource = item
	
	func awake(state_machine: Node) -> void:
		var character: Character = state_machine.owner
		_inventory = Utils.find_node_of_type_in_children(character, CharacterInventory)
	
	func _statement() -> bool:
		return not _inventory.full(_item_resource)
