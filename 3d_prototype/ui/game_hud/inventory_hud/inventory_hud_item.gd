class_name InventoryHUDItem
extends CenterContainer

var _icon: TextureRect
var _amount: Label


func _enter_tree() -> void:
	_icon = $Icon
	_amount = $Icon/MarginContainer/Amount


func configure(texture: Texture, amount: int) -> void:
	_icon.texture = texture
	if amount > 1:
		_amount.visible = true
		_amount.text = ("%d" % amount)
	else:
		_amount.visible = false
