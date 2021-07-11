class_name InventoryHUD
extends ItemHUDBASE

enum SubMenuModes {
	USE,
	EQUIP,
	UNEQUIP,
	DROP,
}

export(Texture) var _use_icon
export(Texture) var _equip_icon
export(Texture) var _unequip_icon   
export(Texture) var _drop_icon


func _enter_tree() -> void:
	var error := Events.hud.connect("inventory_stacks_updated", self, "_on_inventory_stacks_updated")
	assert(error == OK)
	error = Events.hud.connect("inventory_updated", self, "_update_items")
	assert(error == OK)
	error = Events.hud.connect("inventory_hud_toggled", self, "_on_toggled")
	assert(error == OK)


func _exit_tree() -> void:
	Events.hud.disconnect("inventory_stacks_updated", self, "_on_inventory_stacks_updated")
	Events.hud.disconnect("inventory_updated", self, "_update_items")
	Events.hud.disconnect("inventory_hud_toggled", self, "_on_toggled")



func _on_inventory_stacks_updated(new_inventory: CharacterInventory) -> void:
	._on_inventory_stacks_updated(new_inventory)


func _initialize_items(new_inventory: CharacterInventory) -> void:
	._initialize_items(new_inventory)
	
	for item in _items:
		for mode in SubMenuModes.values():
			var icon: Texture
		
			match mode:
				SubMenuModes.USE:
					icon = _use_icon
				SubMenuModes.EQUIP:
					icon = _equip_icon
				SubMenuModes.UNEQUIP:
					icon = _unequip_icon
				SubMenuModes.DROP:
					icon = _drop_icon
			
			var new_item: InventoryHUDItem = _item_scene.instance()
			new_item.texture = icon
			new_item.use = mode
			
			item.possible_submenu_items[mode] = new_item
	
	_set_items(_items)


func _on_toggled(new_inventory: CharacterInventory) -> void:
	._on_toggled(new_inventory)
	
	_update_items()
	
	if _state == MenuState.CLOSED:
		open_menu(get_viewport_rect().size / 2.0)
	elif _state == MenuState.OPEN:
		close_menu()


func _update_items(_new_item: ItemResource = null) -> void:
	var contents := _inventory.item_slots
	
	for i in contents.size():
		var stack: ItemStack = contents[i]
		var hud_item: InventoryHUDItem = _items[i]
		hud_item.item_stack = stack
		
		if stack.item:
			var equipped := _inventory.currently_equipped and _inventory.has_equipped(stack)
			hud_item.disabled = false
			hud_item.equipped = equipped
			hud_item.set_submenu_items(_active_submenus(stack.item, equipped))
		else:
			hud_item.disabled = true
	
	update()


func _on_item_selected(inventory_item: InventoryHUDItem, submenu_item: InventoryHUDItem) -> void:
	if submenu_item:
		var stack: ItemStack = submenu_item.item_stack
		
		match inventory_item.use:
			SubMenuModes.USE:
				_use_item_from_stack(stack)
			SubMenuModes.EQUIP:
				_inventory.equip_item_stack(stack)
			SubMenuModes.UNEQUIP:
				# warning-ignore:return_value_discarded
				_inventory.unequip()
			SubMenuModes.DROP:
				_drop_item_from_stack(stack)
	else:
		assert(false)
	
	_update_items()


func _active_submenus(item: ItemResource, equipped: bool) -> Array:
	var submenu_modes := [ ]
	
	if item is ToolResource:
		submenu_modes += [ SubMenuModes.EQUIP if not equipped else SubMenuModes.UNEQUIP, SubMenuModes.DROP ]
	else:
		submenu_modes += [ SubMenuModes.USE, SubMenuModes.DROP ]
	
	return submenu_modes


func _use_item_from_stack(stack: ItemStack) -> void:
	var items_left_in_stack := _inventory.use_item_from_stack(stack)
	if items_left_in_stack <= 0:
		close_submenu()


func _drop_item_from_stack(stack: ItemStack) -> void:
	if _inventory.currently_equipped and stack == _inventory.currently_equipped.stack:
		# warning-ignore:return_value_discarded
		_inventory.unequip()
	
	var items_left_in_stack := _inventory.drop_item_from_stack(stack)
	if items_left_in_stack <= 0:
		close_submenu()
