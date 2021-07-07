class_name ItemStack

var item: ItemResource
var amount: int


func _init(new_item: ItemResource) -> void:
	item = new_item
	amount = 0


func _to_string() -> String:
	return "Item: [ %s ], Amount: %d" % [ item, amount ]
