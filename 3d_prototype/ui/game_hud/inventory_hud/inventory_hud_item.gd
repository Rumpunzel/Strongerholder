class_name InventoryHUDItem
extends RadialMenuItem

var item_stack: ItemStack setget _set_item_stack
var equipped: bool setget _set_equipped
var amount: int setget _set_amount


func _set_item_stack(new_stack: ItemStack) -> void:
	item_stack = new_stack
	set_texture(item_stack.item.icon)
	_set_amount(item_stack.amount)

func _set_equipped(is_equipped: bool) -> void:
	equipped = is_equipped
	self_modulate = Color("e61972c2") if equipped else Color.white

func _set_amount(new_amount: int) -> void:
	var _amount: Label = $MarginContainer/Amount
	amount = new_amount
	
	if amount > 1:
		_amount.visible = true
		_amount.text = ("%d" % amount)
	else:
		_amount.visible = false
