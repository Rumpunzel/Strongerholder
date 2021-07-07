class_name Inventory
extends Node

signal item_added(item)
signal item_removed(item)

export(Resource) var _inventory_attributes

var _item_stacks: Array = [ ]



func add(item: ItemResource, count: int = 1) -> bool:
	for stack in _item_stacks:
		if item == stack.item:
			count = _add_to_stack(item, count, stack)
			if count <= 0:
				return true
	
	if _item_stacks.size() < _inventory_attributes.inventory_size:
		var new_stack := ItemStack.new(item)
		_item_stacks.append(new_stack)
		emit_signal("item_added", item)
		
		count = _add_to_stack(item, count, new_stack)
		if count <= 0:
			return true
	
	# TODO: drop the remaining items
	return false


func remove(item: ItemResource, count: int = 1) -> bool:
	assert(count > 0)
	
	for stack in _item_stacks:
		if stack.item == item:
			count = _remove_from_stack(item, count, stack)
			if count <= 0:
				return true
	
	return false


func contains(item: ItemResource) -> bool:
	for stack in _item_stacks:
		if stack.item == item:
			return true
	return false


func count(item: ItemResource) -> int:
	var item_count := 0
	for stack in _item_stacks:
		if stack.item == item:
			item_count += stack.amount
	
	return item_count


func contents() -> Array:
	return _item_stacks



func _add_to_stack(item: ItemResource, count: int, stack: ItemStack) -> int:
	while count > 0 and stack.amount < item.stack_size:
		stack.amount += 1
		count -= 1
		emit_signal("item_added", item)
	
	return count


func _remove_from_stack(item: ItemResource, count: int, stack: ItemStack) -> int:
	while count > 0:
		stack.amount -= 1
		count -= 1
		emit_signal("item_removed", item)
		
		if stack.amount <= 0:
			_item_stacks.erase(stack)
			break
	
	return count



func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not _inventory_attributes:
		warning = "InventoryAttributesResource is required"
	elif not _inventory_attributes is InventoryAttributesResource:
		warning = "InventoryAttributesResource is of the wrong type"
	
	return warning
