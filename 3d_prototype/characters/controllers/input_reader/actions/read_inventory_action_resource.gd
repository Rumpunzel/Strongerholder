class_name ReadInventoryActionResource
extends StateActionResource

export(Resource) var inventory_hud_toggled_channel
export(Resource) var inventory_stacks_updated_channel
export(Resource) var inventory_updated_channel

export(Resource) var equipment_hud_toggled_channel
export(Resource) var equipment_stacks_updated_channel
export(Resource) var equipment_updated_channel


func _create_action() -> StateAction:
	return ReadInventoryAction.new()



class ReadInventoryAction extends StateAction:
	var _inventory: CharacterInventory
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_inventory = character.get_inventory()
		
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
	
	
	func on_update(_delta: float) -> void:
		if Input.is_action_just_released("open_inventory"):
			origin_resource.inventory_hud_toggled_channel.raise(_inventory)
		
		if Input.is_action_just_pressed("open_equipment_menu"):
			origin_resource.equipment_hud_toggled_channel.raise(_inventory)
	
	
	func _on_item_stack_changed(_stack: Inventory.ItemStack = null) -> void:
		origin_resource.inventory_stacks_updated_channel.raise(_inventory)
	
	func _on_item_changed(_item: ItemResource = null) -> void:
		origin_resource.inventory_updated_channel.raise(_inventory)
	
	func _on_equipment_stack_changed(_stack: Inventory.ItemStack = null) -> void:
		origin_resource.equipment_stacks_updated_channel.raise(_inventory)
	
	func _on_equipment_changed(_item: ItemResource = null) -> void:
		origin_resource.equipment_updated_channel.raise(_inventory)
