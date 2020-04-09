class_name ActorBehavior
extends Resource


var inventory_empty
var raw_material
var processed_material




func _init(new_inventory_empty: int = Constants.Objects.NOTHING, new_raw_material: int = Constants.Objects.NOTHING, new_processed_material: int = Constants.Objects.NOTHING):
	set_priorities(new_inventory_empty, new_raw_material, new_processed_material)




func next_priority(inventory: Array):
	if inventory.empty():
		return inventory_empty
	else:
		return raw_material


func set_priorities(new_inventory_empty: int, new_raw_material: int, new_processed_material: int):
	inventory_empty = new_inventory_empty
	raw_material = new_raw_material
	processed_material = new_processed_material
