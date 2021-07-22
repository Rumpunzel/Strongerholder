class_name InventoryHUDItem
extends RadialMenuItem

var item_stack: Inventory.ItemStack setget _set_item_stack
var equipped: bool setget _set_equipped
var amount: int setget _set_amount
# warning-ignore:unused_class_variable
var use := -1


func _set_item_stack(new_stack: Inventory.ItemStack) -> void:
	item_stack = new_stack
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	if item_stack and item_stack.item:
		set_texture(item_stack.item.icon)
		_set_amount(item_stack.amount)
	else:
		_set_disabled(true)
		_set_equipped(false)
		set_texture(null)
		_set_amount(0)

func _set_equipped(is_equipped: bool) -> void:
	equipped = is_equipped

func _set_amount(new_amount: int) -> void:
	var _amount: Label = $MarginContainer/Amount
	amount = new_amount
	
	if amount > 1:
		_amount.visible = true
		_amount.text = ("%d" % amount)
	else:
		_amount.visible = false


func is_modified() -> bool:
	return equipped
