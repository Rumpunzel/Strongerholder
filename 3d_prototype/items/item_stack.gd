class_name ItemStack

var item: ItemResource
var amount: int

func _init(new_item: ItemResource, new_amount: int = 1) -> void:
	item = new_item
	amount = new_amount
