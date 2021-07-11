class_name EquipmentHUD
extends ItemHUDBASE


var _equipments := [ ]



func _enter_tree() -> void:
	var error = Events.hud.connect("equipment_stacks_updated", self, "_on_inventory_stacks_updated")
	assert(error == OK)
	error = Events.hud.connect("equipment_updated", self, "_update_items")
	assert(error == OK)
	error = Events.hud.connect("equipment_hud_toggled", self, "_on_toggled")
	assert(error == OK)


func _exit_tree() -> void:
	Events.hud.disconnect("equipment_stacks_updated", self, "_on_inventory_stacks_updated")
	Events.hud.disconnect("equipment_hud_toggled", self, "_on_toggled")


func _on_toggled(new_inventory: CharacterInventory) -> void:
	._on_toggled(new_inventory)
	
	_update_items()
	
	if _state == MenuState.CLOSED:
		if not _equipments.empty():
			open_menu(get_viewport_rect().size / 2.0)
	elif _state == MenuState.OPEN:
		close_menu()


func _update_items(_new_item: ItemResource = null) -> void:
	var contents := _inventory.item_slots
	var size := _inventory.equipments().size()
	var equipment_counter := 0
	_equipments.clear()
	_equipments.resize(size)
	
	for i in contents.size():
		var stack: ItemStack = contents[i]
		var hud_item: InventoryHUDItem = _items[i]
		hud_item.item_stack = stack
		
		if stack.item:
			var equipped := _inventory.currently_equipped and _inventory.has_equipped(stack)
			hud_item.disabled = equipped
			hud_item.equipped = equipped
			
			var instert_index := int(size / 2.0 + ceil(equipment_counter / 2.0) * (equipment_counter if i % 2 == 0 else -1))
			_equipments[instert_index] = hud_item
			equipment_counter += 1
	
	_set_items(_equipments)

func _on_item_selected(inventory_item: InventoryHUDItem, _submenu_item: InventoryHUDItem) -> void:
	if inventory_item == selected_item:
		# warning-ignore:return_value_discarded
		_inventory.unequip()
	else:
		_inventory.equip_item_stack(inventory_item.item_stack)
	
	close_menu()
