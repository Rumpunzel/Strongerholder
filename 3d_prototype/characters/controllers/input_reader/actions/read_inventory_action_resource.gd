class_name ReadInventoryActionResource
extends StateActionResource

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
			Events.hud.emit_signal("inventory_hud_toggled", _inventory)
		
		if Input.is_action_just_pressed("open_equipment_menu"):
			Events.hud.emit_signal("equipment_hud_toggled", _inventory)
	
	
	func _on_item_stack_changed(_stack: ItemStack = null) -> void:
		Events.hud.emit_signal("inventory_stacks_updated", _inventory)
	
	func _on_item_changed(_item: ItemResource = null) -> void:
		Events.hud.emit_signal("inventory_updated", _inventory)
	
	func _on_equipment_stack_changed(_stack: ItemStack = null) -> void:
		Events.hud.emit_signal("equipment_stacks_updated", _inventory)
	
	func _on_equipment_changed(_item: ItemResource = null) -> void:
		Events.hud.emit_signal("equipment_updated", _inventory)
