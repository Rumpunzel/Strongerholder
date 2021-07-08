class_name InventoryHUD
extends CenterContainer

const UNEQUIP = "Unequip"

enum InventoryMode { INVENTORY, EQUIPMENT }

export(Texture) var _unequip_icon

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
	
	_radial_menu = $RadialMenu
	
	error = _radial_menu.connect("item_selected", self, "_on_item_selected")
	assert(error == OK)


func _exit_tree() -> void:
	Events.hud.disconnect("inventory_updated", self, "_on_inventory_updated")
	Events.hud.disconnect("inventory_hud_toggled", self, "_on_toggled")
	
	Events.hud.disconnect("equipment_updated", self, "_on_equipment_updated")
	Events.hud.disconnect("equipment_hud_toggled", self, "_on_toggled")



func _on_inventory_updated(inventory: Inventory) -> void:
	_inventory = inventory
	var contents := inventory.contents(false)
	_items.clear()
	
	for index in contents.size():
		var stack: ItemStack = contents[index]
		if stack:
			_items.append(stack)
		else:
			_items.append(null)


func _on_equipment_updated(inventory: Inventory) -> void:
	_inventory = inventory
	var current_equipments = _inventory.equipments()
	_equipments.clear()
	_equipments.append(_unequip)
	
	for index in current_equipments.size():
		var equipment: ToolResource = current_equipments[index]
		_equipments.append(equipment)


func _on_toggled(mode = _mode) -> void:
	var open_menu := false
	
	if not (mode == _mode and _radial_menu.visible):
		_mode = mode
		
		match _mode:
			InventoryMode.INVENTORY:
				_on_inventory_updated(_inventory)
				
				_radial_menu.center_angle = PI * 0.5 - PI / float(_inventory.size())
				_radial_menu.set_items([ ])
				
				for index in _items.size():
					var stack: ItemStack = _items[index]
					if stack:
						_radial_menu.add_icon_item(stack.item.icon, str(stack.amount), index)
					else:
						_radial_menu.add_icon_item(null, "Nothing", index)
				
				open_menu = true
			
			InventoryMode.EQUIPMENT:
				_on_equipment_updated(_inventory)
				
				if _equipments.size() > 1:
					# TODO: set the correct angle here
					_radial_menu.center_angle = PI
					_radial_menu.set_items([ ])
					_radial_menu.add_icon_item(_unequip_icon, UNEQUIP, 0)
					
					for index in range(1, _equipments.size()):
						var equipment: ToolResource = _equipments[index]
						_radial_menu.add_icon_item(equipment.icon, equipment.name, index)
					
					open_menu = true
	
	if open_menu:
		_radial_menu.open_menu(rect_size * 0.5)
	else:
		_radial_menu.close_menu()


func _on_item_selected(index: int, _position: Vector2) -> void:
	match _mode:
		InventoryMode.INVENTORY:
			pass
		InventoryMode.EQUIPMENT:
			var equipment: ToolResource = _equipments[index]
			if equipment == _unequip:
				_inventory.unequip()
			else:
				_inventory.equip(equipment)
