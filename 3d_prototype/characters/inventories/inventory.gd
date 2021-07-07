class_name Inventory
extends Node

signal item_added(item)
signal item_removed(item)

export(Resource) var _inventory_attributes

var _item_slots: Array = [ ]



func _ready() -> void:
	_item_slots.resize(_inventory_attributes.inventory_size)
	for slot in _item_slots.size():
		_item_slots[slot] = null



func add(item: ItemResource, count: int = 1) -> bool:
	for slot in _item_slots.size():
		var stack: ItemStack = _item_slots[slot]
		if stack:
			if item == stack.item:
				count = _add_to_stack(item, count, stack)
				if count <= 0:
					return true
		else:
			stack = ItemStack.new(item)
			_item_slots[slot] = stack
			
			count = _add_to_stack(item, count, stack)
			if count <= 0:
				return true
	
	# TODO: drop the remaining items
	return false


func remove(item: ItemResource, count: int = 1) -> bool:
	assert(count > 0)
	
	for slot in _item_slots.size():
		var stack: ItemStack = _item_slots[slot]
		if stack and stack.item == item:
			count = _remove_from_stack(item, count, slot)
			if count <= 0:
				break
	
	return count <= 0


func contains(item: ItemResource) -> bool:
	for stack in _item_slots:
		if stack and stack.item == item:
			return true
	return false


func count(item: ItemResource) -> int:
	var item_count := 0
	for stack in _item_slots:
		if stack and stack.item == item:
			item_count += stack.amount
	
	return item_count


func contents(return_only_non_empty := true) -> Array:
	if not return_only_non_empty:
		return _item_slots
	
	var item_stacks := [ ]
	for stack in _item_slots:
		if stack:
			item_stacks.append(stack)
	
	return item_stacks



func _add_to_stack(item: ItemResource, count: int, stack: ItemStack) -> int:
	while count > 0 and stack.amount < item.stack_size:
		stack.amount += 1
		count -= 1
		emit_signal("item_added", item)
	
	return count


func _remove_from_stack(item: ItemResource, count: int, slot: int) -> int:
	var stack: ItemStack = _item_slots[slot]
	while count > 0:
		stack.amount -= 1
		count -= 1
		emit_signal("item_removed", item)
		
		if stack.amount <= 0:
			_item_slots[slot] = null
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
