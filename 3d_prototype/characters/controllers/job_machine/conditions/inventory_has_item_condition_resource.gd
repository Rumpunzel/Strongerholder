class_name InventoryHasItemConditionResource
extends StateConditionResource

export(Resource) var _item = null

func create_condition() -> StateCondition:
	return InventoryHasItemCondition.new(_item)


class InventoryHasItemCondition extends StateCondition:
	var _inventory: CharacterInventory
	
	var _item_resource: ItemResource
	
	
	func _init(item: ItemResource) -> void:
		_item_resource = item
	
	
	func awake(state_machine: Node) -> void:
		var character: Character = state_machine.owner
		_inventory = Utils.find_node_of_type_in_children(character, CharacterInventory)
		# warning-ignore:return_value_discarded
		#_inventory.connect("item_added", self, "_check_items")
		# warning-ignore:return_value_discarded
		#_inventory.connect("item_removed", self, "_check_items")
	
	
	func _check_items(_item: ItemResource = null) -> bool:
		return not _inventory.contains(_item_resource) == null
	
	
	func _statement() -> bool:
		return _check_items()
