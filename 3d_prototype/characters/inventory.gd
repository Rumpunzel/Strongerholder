class_name Inventory
extends Node

signal item_added(item)
signal item_removed(item)

export var _inventory_size: int = 9

var _item_stacks: Array = [ ]


func add(item: ItemResource, count: int = 1) -> bool:
	for stack in _item_stacks:
		if item == stack.item:
			while count > 0 and stack.amount < item.stack_size:
				stack.amount += 1
				count -= 1
				emit_signal("item_added", item)
			
			if count <= 0:
				return true
	
	if _item_stacks.size() < _inventory_size:
		var new_stack := ItemStack.new(item)
		_item_stacks.append(new_stack)
		emit_signal("item_added", item)
		
		while count > 0 and new_stack.amount < item.stack_size:
			new_stack.amount += 1
			count -= 1
			emit_signal("item_added", item)
		
		if count <= 0:
			return true
	
	# TODO: drop the remaining items
	return false


func remove(item: ItemResource, count: int = 1) -> bool:
	assert(count > 0)
	
	for stack in _item_stacks:
		if stack.item == item:
			while count > 0:
				stack.amount -= 1
				count -= 1
				emit_signal("item_removed", item)
				
				if stack.amount <= 0:
					_item_stacks.erase(stack)
					break
			
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
