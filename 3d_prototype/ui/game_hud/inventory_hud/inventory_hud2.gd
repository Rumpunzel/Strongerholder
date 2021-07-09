extends RadialMenu2

enum SubMenuModes {
	USE,
	DROP,
	EQUIP,
	UNEQUIP,
}

export(Texture) var _use_icon
export(Texture) var _drop_icon
export(Texture) var _equip_icon
export(Texture) var _unequip_icon
export(PackedScene) var _item_scene: PackedScene = null

var _inventory: CharacterInventory
var _items := [ ]


func _enter_tree() -> void:
	var error := Events.hud.connect("inventory_updated", self, "_on_inventory_updated")
	assert(error == OK)
	error = Events.hud.connect("inventory_hud_toggled", self, "_on_toggled")
	assert(error == OK)
	
	error = Events.main.connect("game_paused", self, "_on_toggled")
	
	error = connect("item_selected", self, "_on_item_selected")
	assert(error == OK)


func _exit_tree() -> void:
	Events.hud.disconnect("inventory_updated", self, "_on_inventory_updated")
	Events.hud.disconnect("inventory_hud_toggled", self, "_on_toggled")



func _on_inventory_updated(inventory: CharacterInventory) -> void:
	_inventory = inventory
	var contents := inventory.item_slots
	_items.clear()
	
	for stack in contents:
		if stack:
			var new_item: InventoryHUDItem = _item_scene.instance()
			var equipped := _inventory.currently_equipped and _inventory.has_equipped(stack.item)
			new_item.item_stack = stack
			new_item.equipped = equipped
			_items.append(new_item)
		else:
			var new_item: InventoryHUDItem = _item_scene.instance()
			new_item.disabled = true
			_items.append(new_item)
	
	_fill_items()


func _fill_items() -> void:
	#_radial_menu.center_angle = PI * 0.5 - PI / float(_inventory.size())
	_set_items(_items)


func _on_toggled() -> void:
	close_menu()
	
	if not visible:
		_on_inventory_updated(_inventory)
		open_menu(get_viewport_rect().size / 2.0)


func _on_item_selected(inventory_item: InventoryHUDItem, submenu_item: InventoryHUDItem) -> void:
	pass
#			var stack: ItemStack = _items[index]
#
#	match submenu_index:
#		SubMenuModes.USE:
#			_use_item(stack.item, submenu)
#		SubMenuModes.DROP:
#			_drop_item(stack.item, submenu)
#		SubMenuModes.EQUIP:
#			var new_submenu := _equip_item(stack.item, submenu)
#			_on_inventory_updated(_inventory)
#			_radial_menu.close_submenu(submenu)
#			_radial_menu.menu_items[index]['submenu'] = new_submenu
#		SubMenuModes.UNEQUIP:
#			var new_submenu := _equip_item(_unequip, submenu)
#			_on_inventory_updated(_inventory)
#			_radial_menu.close_submenu(submenu)
#			_radial_menu.menu_items[index]['submenu'] = new_submenu
#
#			if _inventory.empty():
#				_radial_menu.close_menu()
#
#		InventoryMode.EQUIPMENT:
#			# warning-ignore:return_value_discarded
#			_equip_item(_equipments[index], submenu)
#			_radial_menu.close_menu()
