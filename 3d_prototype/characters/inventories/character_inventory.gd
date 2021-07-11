class_name CharacterInventory
extends Inventory

signal item_equipped(equipment)
signal item_unequipped(equipment)


export(NodePath) var _hand_position

var currently_equipped: EquippedItem = null


func equipments() -> Array:
	var equipments := [ ]
	for stack in item_slots:
		if stack and stack.item is ToolResource:
			equipments.append(stack)
	
	return equipments


func equip(equipment_stack: ItemStack) -> void:
	#assert(equipments().has(equipment))
	assert(get_node(_hand_position))
	
	# warning-ignore:return_value_discarded
	unequip()
	
	currently_equipped = EquippedItem.new(
			equipment_stack,
			equipment_stack.item.attach_to(get_node(_hand_position))
	)
	
	emit_signal("item_equipped", currently_equipped)


func equip_item_stack(stack: ItemStack) -> void:
	# TODO: Check if this is the proper implementation of this
	equip(stack)


func unequip() -> bool:
	if currently_equipped:
		currently_equipped.node.queue_free()
		emit_signal("item_unequipped", currently_equipped)
		currently_equipped = null
		return true
	
	return false


func has_equipped(equipment_stack: ItemStack) -> bool:
	# TODO: make this a nicer check
	return equipment_stack and currently_equipped and equipment_stack == currently_equipped.stack



func _get_configuration_warning() -> String:
	var warning := ._get_configuration_warning()
	
	if not _hand_position:
		warning = "HandPosition path is required"
	
	return warning




class EquippedItem:
	var stack: ItemStack
	var node: Spatial
	
	func _init(new_stack: ItemStack, new_node: Spatial) -> void:
		stack = new_stack
		node = new_node
