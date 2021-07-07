class_name CharacterInvetory
extends Inventory

signal equipment_added(equipment)
signal equipment_removed(equipment)

signal item_equipped(equipment)
signal item_unequipped(equipment)


export(NodePath) var _hand_position

var _currently_equipped: EquippedItem = null


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
		emit_signal("item_unequipped", _currently_equipped)
		_currently_equipped = null
		return true
	
	return false



func _get_configuration_warning() -> String:
	var warning := ._get_configuration_warning()
	
	if not _hand_position:
		warning = "HandPosition path is required"
	
	return warning




class EquippedItem:
	var item_resource: ItemResource
	var node: Spatial
	
	func _init(new_item_resource: ItemResource, new_node: Spatial) -> void:
		item_resource = new_item_resource
		node = new_node
