class_name InventoryHUD
extends Popup

onready var _item_list: ItemList = $ItemList


func _ready():
	var error := Events.hud.connect("inventory_updated", self, "_on_inventory_updated")
	assert(error == OK)
	error = Events.hud.connect("inventory_hud_toggled", self, "_on_inventory_hud_toggled")
	assert(error == OK)


func _on_inventory_updated(inventory: Inventory) -> void:
	_item_list.clear()
	for stack in inventory.contents():
		if stack.amount > 1:
			_item_list.add_item(str(stack.amount), stack.item.icon)
		else:
			_item_list.add_icon_item(stack.item.icon)

func _on_inventory_hud_toggled() -> void:
	if visible:
		hide()
	else:
		popup()
