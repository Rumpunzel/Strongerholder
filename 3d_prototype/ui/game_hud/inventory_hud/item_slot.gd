class_name ItemSlot
extends PanelContainer

onready var _inventory_item: Control = $InventoryItem
onready var _icon: TextureRect = $InventoryItem/Icon
onready var _amount: Label = $InventoryItem/Amount



func _ready() -> void:
	remove()



func add(item_stack: ItemStack) -> void:
	var amount := item_stack.amount
	
	if amount > 0:
		_icon.texture = item_stack.item.icon
		_amount.text = ("%d" % amount) if amount > 1 else ""
		_inventory_item.visible = true
	else:
		remove()


func remove() -> void:
	_inventory_item.visible = false
	_icon.texture = null
	_amount.text = ""
