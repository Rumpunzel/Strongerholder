class_name Inventory
extends Node
tool

signal item_added(item)
signal item_removed(item)
signal equipment_added(equipment)
signal equipment_removed(equipment)

signal item_equipped()
signal item_unequipped()


export(Resource) var _inventory_attributes
export(NodePath) var _hand_position


var _item_slots := [ ]
var _currently_equipped: EquippedItem = null



func _enter_tree() -> void:
	if Engine.editor_hint:
		return
	
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


func equipments() -> Array:
	var equipments := [ ]
	for stack in _item_slots:
		if stack and stack.item is ToolResource:
			equipments.append(stack.item)
	
	return equipments


func equip(equipment: ToolResource) -> void:
	assert(equipments().has(equipment))
	assert(get_node(_hand_position))
	
	unequip()
	
	_currently_equipped = EquippedItem.new(
			equipment,
			equipment.attach_to(get_node(_hand_position))
	)
	
	emit_signal("item_equipped", _currently_equipped)


func unequip() -> bool:
	if _currently_equipped:
		_currently_equipped.node.queue_free()
		_currently_equipped = null
		emit_signal("item_unequipped")
		return true
	
	return false



func _add_to_stack(item: ItemResource, count: int, stack: ItemStack) -> int:
	while count > 0 and stack.amount < item.stack_size:
		stack.amount += 1
		count -= 1
		emit_signal("item_added", item)
		if item is ToolResource:
			emit_signal("equipment_added", item)
	
	return count


func _remove_from_stack(item: ItemResource, count: int, slot: int) -> int:
	var stack: ItemStack = _item_slots[slot]
	while count > 0:
		stack.amount -= 1
		count -= 1
		emit_signal("item_removed", item)
		if item is ToolResource:
			emit_signal("equipment_removed", item)
		
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
	
	if not _hand_position:
		warning = "HandPosition path is required"
	
	return warning



class EquippedItem:
	var item_resource: ItemResource
	var node: Spatial
	
	func _init(new_item_resource: ItemResource, new_node: Spatial) -> void:
		item_resource = new_item_resource
		node = new_node
