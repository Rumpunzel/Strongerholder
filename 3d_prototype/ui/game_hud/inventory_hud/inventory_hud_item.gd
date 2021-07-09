class_name InventoryHUDItem
extends RadialMenuItem


func configure(new_texture: Texture, amount: int, is_disabled := false) -> void:
	texture = new_texture
	
	var _amount: Label  = $MarginContainer/Amount
	if amount > 1:
		_amount.visible = true
		_amount.text = ("%d" % amount)
	else:
		_amount.visible = false
	
	_set_disabled(is_disabled)
