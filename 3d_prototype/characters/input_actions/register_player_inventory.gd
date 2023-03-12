extends ActionLeaf

export(Resource) var _inventory_stacks_updated_channel
export(Resource) var _inventory_updated_channel

export(Resource) var _equipment_stacks_updated_channel
export(Resource) var _equipment_updated_channel

var _inventory: CharacterInventory setget _set_inventory


func on_update(blackboard: CharacterController.CharacterBlackboard) -> int:
	_set_inventory(blackboard.inventory)
	return Status.SUCCESS


func _set_inventory(new_inventory: CharacterInventory) -> void:
	if _inventory:
		_unregister_inventory()
	
	_inventory = new_inventory
	_register_inventory()


func _register_inventory() -> void:
	# warning-ignore:return_value_discarded
	_inventory.connect("item_stack_added", self, "_on_item_stack_changed")
	# warning-ignore:return_value_discarded
	_inventory.connect("item_stack_removed", self, "_on_item_stack_changed")
	# warning-ignore:return_value_discarded
	_inventory.connect("item_added", self, "_on_item_changed")
	# warning-ignore:return_value_discarded
	_inventory.connect("item_removed", self, "_on_item_changed")
	
	# warning-ignore:return_value_discarded
	_inventory.connect("equipment_stack_added", self, "_on_equipment_stack_changed")
	# warning-ignore:return_value_discarded
	_inventory.connect("equipment_stack_removed", self, "_on_equipment_stack_changed")
	# warning-ignore:return_value_discarded
	_inventory.connect("equipment_added", self, "_on_equipment_changed")
	# warning-ignore:return_value_discarded
	_inventory.connect("equipment_removed", self, "_on_equipment_changed")


func _unregister_inventory() -> void:
	_inventory.disconnect("item_stack_added", self, "_on_item_stack_changed")
	_inventory.disconnect("item_stack_removed", self, "_on_item_stack_changed")
	_inventory.disconnect("item_added", self, "_on_item_changed")
	_inventory.disconnect("item_removed", self, "_on_item_changed")
	
	_inventory.disconnect("equipment_stack_added", self, "_on_equipment_stack_changed")
	_inventory.disconnect("equipment_stack_removed", self, "_on_equipment_stack_changed")
	_inventory.disconnect("equipment_added", self, "_on_equipment_changed")
	_inventory.disconnect("equipment_removed", self, "_on_equipment_changed")


func _on_item_stack_changed(_stack: Inventory.ItemStack = null) -> void:
	# warning-ignore-all:unsafe_property_access
	_inventory_stacks_updated_channel.raise(_inventory)

func _on_item_changed(_item: ItemResource = null) -> void:
	# warning-ignore-all:unsafe_property_access
	_inventory_updated_channel.raise(_inventory)

func _on_equipment_stack_changed(_stack: Inventory.ItemStack = null) -> void:
	# warning-ignore-all:unsafe_property_access
	_equipment_stacks_updated_channel.raise(_inventory)

func _on_equipment_changed(_item: ItemResource = null) -> void:
	# warning-ignore-all:unsafe_property_access
	_equipment_updated_channel.raise(_inventory)
