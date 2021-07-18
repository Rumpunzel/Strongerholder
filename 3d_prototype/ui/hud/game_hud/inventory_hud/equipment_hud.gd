class_name EquipmentHUD
extends ItemHUDBASE

export(Resource) var _equipment_hud_toggled_channel
export(Resource) var _equipment_stacks_updated_channel
export(Resource) var _equipment_updated_channel

var _equipments := [ ]


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_equipment_hud_toggled_channel.connect("raised", self, "_on_toggled")
	# warning-ignore:return_value_discarded
	_equipment_stacks_updated_channel.connect("raised", self, "_on_inventory_stacks_updated")
	# warning-ignore:return_value_discarded
	_equipment_updated_channel.connect("raised", self, "_update_items")

func _exit_tree() -> void:
	_equipment_hud_toggled_channel.disconnect("raised", self, "_on_toggled")
	_equipment_stacks_updated_channel.disconnect("raised", self, "_on_inventory_stacks_updated")
	_equipment_updated_channel.disconnect("raised", self, "_update_items")


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
		var stack: Inventory.ItemStack = contents[i]
		
		if not stack.item is ToolResource:
			continue
		
		var hud_item: InventoryHUDItem = _items[i]
		hud_item.item_stack = stack
		
		if stack.item:
			var equipped := _inventory.has_equipped(stack)
			hud_item.disabled = false
			hud_item.equipped = equipped
			
			var insert_index := int(size / 2.0 + ceil(equipment_counter / 2.0) * (1 if i % 2 == 0 else -1))
			_equipments[insert_index] = hud_item
			equipment_counter += 1
	
	_set_items(_equipments)


func _on_item_selected(inventory_item: InventoryHUDItem, _submenu_item: InventoryHUDItem) -> void:
	if _inventory.has_equipped(inventory_item.item_stack):
		# warning-ignore:return_value_discarded
		_inventory.unequip()
	else:
		_inventory.equip_item_stack(inventory_item.item_stack)
	
	close_menu()
