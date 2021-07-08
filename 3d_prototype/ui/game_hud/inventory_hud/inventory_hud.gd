class_name InventoryHUD
extends Control

const UNEQUIP = "Unequip"

enum InventoryMode { INVENTORY, EQUIPMENT }
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
export var _submenu_icon_width := 0.07

var _radial_menu: RadialMenu
var _inventory: CharacterInvetory

var _mode: int
var _items := [ ]
var _equipments := [ ]
var _unequip := ToolResource.new()



func _enter_tree() -> void:
	var error := Events.hud.connect("inventory_updated", self, "_on_inventory_updated")
	assert(error == OK)
	error = Events.hud.connect("inventory_hud_toggled", self, "_on_toggled", [ InventoryMode.INVENTORY ])
	assert(error == OK)
	
	error = Events.hud.connect("equipment_updated", self, "_on_equipment_updated")
	assert(error == OK)
	error = Events.hud.connect("equipment_hud_toggled", self, "_on_toggled", [ InventoryMode.EQUIPMENT ])
	assert(error == OK)
	
	error = Events.main.connect("game_paused", self, "_on_toggled", [ -1 ])
	
	_radial_menu = $RadialMenu
	
	error = _radial_menu.connect("item_selected", self, "_on_item_selected")
	assert(error == OK)


func _exit_tree() -> void:
	Events.hud.disconnect("inventory_updated", self, "_on_inventory_updated")
	Events.hud.disconnect("inventory_hud_toggled", self, "_on_toggled")
	
	Events.hud.disconnect("equipment_updated", self, "_on_equipment_updated")
	Events.hud.disconnect("equipment_hud_toggled", self, "_on_toggled")



func _on_inventory_updated(inventory: Inventory) -> bool:
	_inventory = inventory
	var contents := inventory.contents(false)
	_items.clear()
	
	for index in contents.size():
		var stack: ItemStack = contents[index]
		if stack:
			_items.append(stack)
		else:
			_items.append(null)
	
	if _mode == InventoryMode.INVENTORY:
		_fill_items()
		return true
	
	return false


func _on_equipment_updated(inventory: Inventory) -> bool:
	_inventory = inventory
	var current_equipments = _inventory.equipments()
	_equipments.clear()
	_equipments.append(_unequip)
	
	for index in current_equipments.size():
		var equipment: ToolResource = current_equipments[index]
		_equipments.append(equipment)
	
	if _mode == InventoryMode.EQUIPMENT and _equipments.size() > 1:
		_fill_equipments()
		return true
	
	return false


func _on_toggled(mode := _mode) -> void:
	var open_menu := false
	_radial_menu.close_menu()
	
	if not (mode == _mode and _radial_menu.visible):
		_mode = mode
		
		match _mode:
			InventoryMode.INVENTORY:
				open_menu = _on_inventory_updated(_inventory)
			
			InventoryMode.EQUIPMENT:
				open_menu = _on_equipment_updated(_inventory)
	
	if open_menu:
		_radial_menu.open_menu(rect_size * 0.5)


func _fill_items() -> void:
	_radial_menu.center_angle = PI * 0.5 - PI / float(_inventory.size())
	_radial_menu.set_items([ ])
	
	for index in _items.size():
		var stack: ItemStack = _items[index]
		if stack:
			var item := stack.item
			var equipped := _inventory.currently_equipped and item == _inventory.currently_equipped.item_resource
			_radial_menu.add_icon_item(item.icon, str(stack.amount), index, false, _create_submenu(item, equipped))
		else:
			_radial_menu.add_icon_item(null, "Nothing", index, true, null)


func _fill_equipments() -> void:
	# TODO: set the correct angle here
	_radial_menu.center_angle = -PI * 0.5 - PI / float(_equipments.size())
	_radial_menu.set_items([ ])
	_radial_menu.add_icon_item(_unequip_icon, UNEQUIP, 0, not _inventory.currently_equipped, null)
	
	for index in range(1, _equipments.size()):
		var equipment: ToolResource = _equipments[index]
		var equipped := _inventory.currently_equipped and equipment == _inventory.currently_equipped.item_resource
		_radial_menu.add_icon_item(equipment.icon, equipment.name, index, equipped, null)


func _on_item_selected(index: int, submenu_index, _position: Vector2) -> void:
	match _mode:
		InventoryMode.INVENTORY:
			var stack: ItemStack = _items[index]
			
			match submenu_index:
				SubMenuModes.USE:
					var item: ItemResource = stack.item
					item.use()
					_inventory.remove(item)
					_on_inventory_updated(_inventory)
				SubMenuModes.DROP:
					var item: ItemResource = stack.item
					# TODO: call dropping
					print("Dropped %s" % item)
				SubMenuModes.EQUIP:
					_equip_item(stack.item)
					_radial_menu.menu_items[index].submenu = _create_submenu(stack.item, true)
				SubMenuModes.UNEQUIP:
					_equip_item(_unequip)
					_radial_menu.menu_items[index].submenu = _create_submenu(stack.item, false)
		
		InventoryMode.EQUIPMENT:
			_equip_item(_equipments[index])


func _create_submenu(item: ItemResource, equipped: bool) -> RadialMenu:
	# create a new radial menu
	var submenu := RadialMenu.new()
	# copy some important properties from the parent menu
	submenu.width = _radial_menu.width
	submenu.default_theme = _radial_menu.default_theme
	submenu.set_items([ ])
	
	var submenu_modes := [ ]
	if item is ToolResource:
		submenu_modes += [ SubMenuModes.EQUIP if not equipped else SubMenuModes.UNEQUIP, SubMenuModes.DROP ]
	else:
		submenu_modes += [ SubMenuModes.USE, SubMenuModes.DROP ]
	
	for mode in submenu_modes:
		var icon: Texture
		
		match mode:
			SubMenuModes.USE:
				icon = _use_icon
			SubMenuModes.DROP:
				icon = _drop_icon
			SubMenuModes.EQUIP:
				icon = _equip_icon
			SubMenuModes.UNEQUIP:
				icon = _unequip_icon
		
		submenu.add_icon_item(icon, SubMenuModes.keys()[mode], mode, false, null)
	
	submenu.circle_coverage = (_submenu_icon_width * submenu_modes.size()) / _radial_menu.circle_coverage
	return submenu


func _equip_item(equipment: ToolResource) -> void:
	_radial_menu.close_menu()
	
	if equipment == _unequip:
		_inventory.unequip()
	else:
		_inventory.equip(equipment)


func _drop_item(item: ItemResource) -> void:
	_radial_menu.close_menu(true)
