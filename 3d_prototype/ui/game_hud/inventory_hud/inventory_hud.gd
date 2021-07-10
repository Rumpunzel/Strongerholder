class_name InventoryHUD
extends ItemHUDBASE

enum SubMenuModes {
	UNEQUIP,
	EQUIP,
	USE,
	DROP,
}

export(Texture) var _equip_icon
export(Texture) var _use_icon
export(Texture) var _drop_icon


var _items := [ ]


func _enter_tree() -> void:
	var error := Events.hud.connect("inventory_updated", self, "_on_inventory_updated")
	assert(error == OK)
	error = Events.hud.connect("inventory_hud_toggled", self, "_on_toggled")
	assert(error == OK)
	
	error = connect("item_selected", self, "_on_item_selected")
	assert(error == OK)


func _exit_tree() -> void:
	Events.hud.disconnect("inventory_updated", self, "_on_inventory_updated")
	Events.hud.disconnect("inventory_hud_toggled", self, "_on_toggled")



func _on_inventory_updated(inventory: CharacterInventory) -> void:
	_inventory = inventory
	var contents := inventory.item_slots
	var size := contents.size()
	_items.clear()
	_items.resize(size)
	
	for i in range(size):
		var stack: ItemStack = contents[i]
		var new_item: InventoryHUDItem = _item_scene.instance()
		
		if stack:
			var equipped := _inventory.currently_equipped and _inventory.has_equipped(stack.item)
			new_item.item_stack = stack
			new_item.equipped = equipped
			new_item.submenu_items = _create_submenu(stack.item, equipped)
		else:
			new_item.disabled = true
		
		var instert_index := int(size / 2.0 + i) % size
		_items[i] = new_item
	
	_set_items(_items)


func _create_submenu(item: ItemResource, equipped: bool) -> Array:
	var submenu := [ ]
	var submenu_modes := [ ]
	
	if item is ToolResource:
		submenu_modes += [ SubMenuModes.EQUIP if not equipped else SubMenuModes.UNEQUIP, SubMenuModes.DROP ]
	else:
		submenu_modes += [ SubMenuModes.USE, SubMenuModes.DROP ]
	
	for mode in submenu_modes:
		var icon: Texture
		
		match mode:
			SubMenuModes.UNEQUIP:
				icon = _unequip_icon
			SubMenuModes.EQUIP:
				icon = _equip_icon
			SubMenuModes.USE:
				icon = _use_icon
			SubMenuModes.DROP:
				icon = _drop_icon
		
		var new_item: InventoryHUDItem = _item_scene.instance()
		new_item.texture = icon
		new_item.use = mode
		submenu.append(new_item)
	
	return submenu


func _on_toggled() -> void:
	if _state == MenuState.CLOSED:
		_on_inventory_updated(_inventory)
		open_menu(get_viewport_rect().size / 2.0)
	elif _state == MenuState.OPEN:
		close_menu()


func _on_item_selected(inventory_item: InventoryHUDItem, submenu_item: InventoryHUDItem) -> void:
	var stack: ItemStack = submenu_item.item_stack
	
	match inventory_item.use:
		SubMenuModes.USE:
			_use_item_from_stack(stack)
		SubMenuModes.DROP:
			_drop_item_from_stack(stack)
		SubMenuModes.EQUIP:
			_equip_item_from_stack(stack)
		SubMenuModes.UNEQUIP:
			_equip_item_from_stack(_unequip)
	
	_on_inventory_updated(_inventory)
	if _inventory.empty():
		close_menu()


func _equip_item_from_stack(stack: ItemStack) -> void:
	._equip_item_from_stack(stack)
	close_submenu()


func _use_item_from_stack(item: ItemStack) -> void:
	var items_left_in_stack := _inventory.use_item_from_stack(item)
	if items_left_in_stack <= 0:
		close_submenu()


func _drop_item_from_stack(item: ItemStack) -> void:
	var equipped := _inventory.currently_equipped and item == _inventory.currently_equipped.item_resource
	if equipped:
		# warning-ignore:return_value_discarded
		_inventory.unequip()
	
	var items_left_in_stack := _inventory.drop_item_from_stack(item)
	
	if items_left_in_stack <= 0:
		close_submenu()
