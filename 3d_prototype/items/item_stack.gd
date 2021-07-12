class_name ItemStack
extends Reference

var item: ItemResource
var amount: int


func _init(new_item: ItemResource) -> void:
	item = new_item
	amount = 0


func reset() -> void:
	item = null
	amount = 0


func save_to_var(save_file: File) -> void:
	if item:
		# Store resource path
		save_file.store_var(item.resource_path)
	else:
		save_file.store_var(null)
	save_file.store_var(amount)

func load_from_var(save_file: File) -> void:
	# Load as resource
	var loaded_item: ItemResource = null
	var stored_item = save_file.get_var()
	if stored_item:
		loaded_item = load(stored_item)
	
	item = loaded_item
	amount = save_file.get_var()


func _to_string() -> String:
	return "Item: [ %s ], Amount: %d" % [ item, amount ]
