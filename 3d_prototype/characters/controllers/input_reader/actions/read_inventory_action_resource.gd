class_name ReadInventoryActionResource
extends StateActionResource

# warning-ignore:unused_class_variable
export(Resource) var inventory_hud_toggled_channel
# warning-ignore:unused_class_variable
export(Resource) var inventory_stacks_updated_channel
# warning-ignore:unused_class_variable
export(Resource) var inventory_updated_channel

# warning-ignore:unused_class_variable
export(Resource) var equipment_hud_toggled_channel
# warning-ignore:unused_class_variable
export(Resource) var equipment_stacks_updated_channel
# warning-ignore:unused_class_variable
export(Resource) var equipment_updated_channel


func _create_action() -> StateAction:
	return ReadInventoryAction.new()



class ReadInventoryAction extends StateAction:
	var _character: Character
	var _inventory: CharacterInventory
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_inventory = _character.get_inventory()
		
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
	
	
	func on_input(input: InputEvent) -> void:
		if input.is_action_pressed("open_inventory"):
			# warning-ignore-all:unsafe_property_access
			origin_resource.inventory_hud_toggled_channel.raise(_inventory)
			_character.get_tree().set_input_as_handled()
		
		if input.is_action_pressed("open_equipment_menu"):
			# warning-ignore-all:unsafe_property_access
			origin_resource.equipment_hud_toggled_channel.raise(_inventory)
			_character.get_tree().set_input_as_handled()
	
	
	func _on_item_stack_changed(_stack: Inventory.ItemStack = null) -> void:
		# warning-ignore-all:unsafe_property_access
		origin_resource.inventory_stacks_updated_channel.raise(_inventory)
	
	func _on_item_changed(_item: ItemResource = null) -> void:
		# warning-ignore-all:unsafe_property_access
		origin_resource.inventory_updated_channel.raise(_inventory)
	
	func _on_equipment_stack_changed(_stack: Inventory.ItemStack = null) -> void:
		# warning-ignore-all:unsafe_property_access
		origin_resource.equipment_stacks_updated_channel.raise(_inventory)
	
	func _on_equipment_changed(_item: ItemResource = null) -> void:
		# warning-ignore-all:unsafe_property_access
		origin_resource.equipment_updated_channel.raise(_inventory)
