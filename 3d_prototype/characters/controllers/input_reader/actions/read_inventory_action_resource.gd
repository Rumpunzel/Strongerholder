class_name ReadInventoryActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadInventoryAction.new()


class ReadInventoryAction extends StateAction:
	var _inventory: Inventory
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_inventory = character.get_inventory()
		var error := _inventory.connect("item_added", self, "_on_item_changed")
		assert(error == OK)
		error = _inventory.connect("item_removed", self, "_on_item_changed")
		assert(error == OK)
	
	
	func on_update(_delta: float) -> void:
		if Input.is_action_just_released("open_inventory"):
			Events.hud.emit_signal("inventory_hud_toggled")
	
	
	func _on_item_changed(_item: ItemResource) -> void:
		Events.hud.emit_signal("inventory_updated", _inventory.contents(false))
