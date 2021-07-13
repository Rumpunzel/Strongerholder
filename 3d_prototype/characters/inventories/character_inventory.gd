class_name CharacterInventory
extends Inventory


signal item_equipped(equipment)
signal item_unequipped(equipment)

export(NodePath) var _hand_position
export var _equip_first_item := true

var _currently_equipped := EquippedItem.new()



func equipments() -> Array:
	var equipments := [ ]
	for stack in item_slots:
		if stack and stack.item is ToolResource:
			equipments.append(stack)
	
	return equipments


func equip_item_stack(equipment_stack: Inventory.ItemStack) -> void:
	assert(equipments().has(equipment_stack))
	assert(get_node(_hand_position))
	
	# warning-ignore:return_value_discarded
	unequip()
	
	_currently_equipped.set_stack(item_slots.find(equipment_stack), equipment_stack, get_node(_hand_position))
	emit_signal("item_equipped", _currently_equipped)


func unequip() -> bool:
	if _currently_equipped.stack_id >= 0:
		emit_signal("item_unequipped", _currently_equipped)
		_currently_equipped.unequip()
		return true
	
	return false


func has_equipped(equipment_stack: Inventory.ItemStack) -> bool:
	# TODO: make this a nicer check
	return equipment_stack and equipment_stack == item_slots[_currently_equipped.stack_id]

func has_something_equipped() -> bool:
	return _currently_equipped.stack_id >= 0


func save_to_var(save_file: File) -> void:
	.save_to_var(save_file)
	# Save as data
	save_file.store_var(_currently_equipped.stack_id)

func load_from_var(save_file: File) -> void:
	.load_from_var(save_file)
	# Load as data and equip
	var current_stack_id: int = save_file.get_var()
	if current_stack_id >= 0:
		equip_item_stack(item_slots[current_stack_id])


func _on_equipment_stack_added(new_equipment_stack: Inventory.ItemStack) -> void:
	if _equip_first_item and _currently_equipped.stack_id < 0:
		equip_item_stack(new_equipment_stack)


func _get_configuration_warning() -> String:
	var warning := ._get_configuration_warning()
	
	if not _hand_position:
		warning = "HandPosition path is required"
	
	return warning



class EquippedItem:
	var stack_id: int = -1
	var stack: Inventory.ItemStack = Inventory.ItemStack.new(null)
	var node: Spatial = null
	
	func unequip() -> void:
		stack_id = -1
		stack = Inventory.ItemStack.new(null)
		if node:
			node.queue_free()
			node = null
	
	func set_stack(new_stack_id: int, new_stack: Inventory.ItemStack, hand_position: Spatial) -> void:
		assert(new_stack)
		assert(hand_position)
		stack_id = new_stack_id
		
		stack = new_stack
		if stack.item:
			node = stack.item.attach_to(hand_position)
		elif node:
			node.queue_free()
			node = null
