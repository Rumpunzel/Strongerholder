class_name EquipmentHUD
extends CenterContainer

const UNEQUIP = "Unequip"

export(Texture) var _unequip_icon

var _equipments := [ ]

onready var _radial_menu: RadialMenu = $RadialMenu


func _ready():
	_on_equipment_updated([ ])
	
	var error := Events.hud.connect("equipment_updated", self, "_on_equipment_updated")
	assert(error == OK)
	error = Events.hud.connect("equipment_hud_toggled", self, "_on_equipment_hud_toggled")
	assert(error == OK)
	
#	for item_slot in _item_slots:
#		error = item_slot.connect("item_stack_dropped", self, "_on_item_stack_dropped")
#		assert(error == OK) item_selected


func _on_equipment_updated(equipments: Array) -> void:
	_equipments = equipments
	_radial_menu.set_items([ ])
	
	for index in _equipments.size():
		var equipment: ToolResource = _equipments[index]
		_radial_menu.add_icon_item(equipment.icon, equipment.name, index)
	
	_radial_menu.add_icon_item(_unequip_icon, UNEQUIP, _equipments.size() + 1)


func _on_equipment_hud_toggled() -> void:
	if _radial_menu.visible:
		_radial_menu.close_menu()
	else:
		_radial_menu.open_menu(rect_size * 0.5)
