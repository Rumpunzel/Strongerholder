class_name ReadEquipmentActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadEquipmentAction.new()


class ReadEquipmentAction extends StateAction:
	var _inventory: CharacterInvetory
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_inventory = character.get_inventory()
		var error := _inventory.connect("equipment_added", self, "_on_equipment_changed")
		assert(error == OK)
		error = _inventory.connect("equipment_removed", self, "_on_equipment_changed")
		assert(error == OK)
	
	
	func on_state_enter() -> void:
		_on_equipment_changed()
	
	func on_update(_delta: float) -> void:
		if Input.is_action_just_pressed("open_equipment_menu"):
			Events.hud.emit_signal("equipment_hud_toggled")
	
	
	func _on_equipment_changed(_item: ItemResource = null) -> void:
		Events.hud.emit_signal("equipment_updated", _inventory)
