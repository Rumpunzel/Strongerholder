class_name EquipmentHUD
extends ItemHUDBASE


var _equipments := [ ]



func _enter_tree() -> void:
	var error = Events.hud.connect("equipment_updated", self, "_on_equipment_updated")
	assert(error == OK)
	error = Events.hud.connect("equipment_hud_toggled", self, "_on_toggled")
	assert(error == OK)
	
	error = connect("item_selected", self, "_on_item_selected")
	assert(error == OK)


func _exit_tree() -> void:
	Events.hud.disconnect("equipment_updated", self, "_on_equipment_updated")
	Events.hud.disconnect("equipment_hud_toggled", self, "_on_toggled")



func _on_equipment_updated(inventory: CharacterInventory) -> bool:
	_inventory = inventory
	if not _inventory:
		return false
	
	var current_equipment_stacks := _inventory.equipments()
	var size := current_equipment_stacks.size()
	_equipments.clear()
	_equipments.resize(size)
	
	for i in range(size):
		var stack: ItemStack = current_equipment_stacks[i]
		var new_item: InventoryHUDItem = _item_scene.instance()
		var equipped := _inventory.currently_equipped and _inventory.has_equipped(stack.item)
		new_item.item_stack = stack
		new_item.disabled = equipped
		new_item.equipped = equipped
		
		var instert_index := int(size / 2.0 + ceil(i / 2.0) * (1 if i % 2 == 0 else -1))
		_equipments[instert_index] = new_item
	
	var unequip_item: InventoryHUDItem = _item_scene.instance()
	unequip_item.item_stack = _unequip
	unequip_item.disabled = not _inventory.currently_equipped
	_equipments.append(unequip_item)
	
	if _equipments.size() > 1:
		_set_items(_equipments)
		return true
	
	return false


func _on_toggled() -> void:
	if _state == MenuState.CLOSED:
		var open_menu := _on_equipment_updated(_inventory)
		if open_menu:
			open_menu(get_viewport_rect().size / 2.0)
	elif _state == MenuState.OPEN:
		close_menu()


func _on_item_selected(inventory_item: InventoryHUDItem, _submenu_item: InventoryHUDItem) -> void:
	# warning-ignore:return_value_discarded
	_equip_item_from_stack(inventory_item.item_stack)
	close_menu()
