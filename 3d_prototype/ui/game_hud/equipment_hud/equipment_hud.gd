class_name EquipmentHUD
extends CenterContainer

const UNEQUIP = "Unequip"

export(Texture) var _unequip_icon

var _inventory: CharacterInvetory
var _equipments := [ ]
var _unequip: ToolResource

var _radial_menu: RadialMenu



func _enter_tree() -> void:
	var error := Events.hud.connect("equipment_updated", self, "_on_equipment_updated")
	assert(error == OK)
	error = Events.hud.connect("equipment_hud_toggled", self, "_on_equipment_hud_toggled")
	assert(error == OK)
	
	_radial_menu = $RadialMenu
	
	error = _radial_menu.connect("item_selected", self, "_on_item_selected")
	assert(error == OK)


func _exit_tree() -> void:
	Events.hud.disconnect("equipment_updated", self, "_on_equipment_updated")
	Events.hud.disconnect("equipment_hud_toggled", self, "_on_equipment_hud_toggled")



func _on_equipment_updated(inventoy: Inventory) -> void:
	_inventory = inventoy
	var current_equipments = _inventory.equipments()
	_equipments.clear()
	_radial_menu.set_items([ ])
	
	_radial_menu.add_icon_item(_unequip_icon, UNEQUIP, 0)
	_unequip = ToolResource.new()
	_equipments.append(_unequip)
	
	for index in current_equipments.size():
		var equipment: ToolResource = current_equipments[index]
		_radial_menu.add_icon_item(equipment.icon, equipment.name, index + 1)
		_equipments.append(equipment)


func _on_equipment_hud_toggled() -> void:
	if _radial_menu.visible:
		_radial_menu.close_menu()
	elif _equipments.size() > 1:
		_radial_menu.open_menu(rect_size * 0.5)


func _on_item_selected(index: int, _position: Vector2) -> void:
	var equipment: ToolResource = _equipments[index]
	if equipment == _unequip:
		_inventory.unequip()
	else:
		_inventory.equip(equipment)
