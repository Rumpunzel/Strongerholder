class_name Inventory
extends Area
tool

signal item_added(item)
signal item_removed(item)

signal equipment_added(equipment)
signal equipment_removed(equipment)

export(Resource) var _inventory_attributes

var item_slots := [ ]

onready var _drop_area: CollisionShape = $CollisionShape
onready var _drop_shape: BoxShape = _drop_area.shape



func _enter_tree() -> void:
	if Engine.editor_hint:
		return
	
	item_slots.resize(_inventory_attributes.inventory_size)
	for slot in item_slots.size():
		item_slots[slot] = null


func _ready() -> void:
	for item in _inventory_attributes.starting_items:
		# warning-ignore:return_value_discarded
		add(item)



# Returns how many items were dropped because the inventory was full
func add(item: ItemResource, count := 1) -> int:
	assert(count > 0)
	for slot in item_slots.size():
		var stack: ItemStack = item_slots[slot]
		if stack:
			if item == stack.item:
				count = _add_to_stack(item, count, stack)
				if count <= 0:
					break
		else:
			stack = ItemStack.new(item)
			item_slots[slot] = stack
			
			count = _add_to_stack(item, count, stack)
			if count <= 0:
				break
	
	for _i in range(count):
		_spawn_item(item)
	
	return count


# Returns how many are left in the stack
func remove(item: ItemResource) -> int:
	var left_in_stack := -1
	for slot in item_slots.size():
		var stack: ItemStack = item_slots[slot]
		if stack and stack.item == item:
			left_in_stack = _remove_from_stack(item, 1, slot)
			break
	
	return left_in_stack


# Returns how many are left in the stack
func use(item: ItemResource) -> int:
	var left_in_stack := -1
	for slot in item_slots.size():
		var stack: ItemStack = item_slots[slot]
		if stack and stack.item == item:
			left_in_stack = _remove_from_stack(item, 1, slot)
			break
	
	if left_in_stack < 0:
		printerr("Tried to use [ %s ] from %s but there were none in inventory." % [ item, owner.name ])
		return left_in_stack
	
	item.use()
	return left_in_stack


# Returns how many are left in the stack
func drop(item: ItemResource) -> int:
	var left_in_stack := -1
	for slot in item_slots.size():
		var stack: ItemStack = item_slots[slot]
		if stack and stack.item == item:
			left_in_stack = _remove_from_stack(item, 1, slot)
			break
	
	if left_in_stack < 0:
		printerr("Tried to drop [ %s ] from %s but there were none in inventory." % [ item, owner.name ])
		return left_in_stack
	
	_spawn_item(item)
	return left_in_stack


# Returns how many items were dropped
func drop_stack(stack: ItemStack) -> int:
	if not item_slots.has(stack):
		return 0
	
	var amount := stack.amount
	for _i in range(amount):
		# warning-ignore:return_value_discarded
		drop(stack.item)
	
	return amount


func drop_everything() -> void:
	for stack in contents():
		# warning-ignore:return_value_discarded
		drop_stack(stack)


func contains(item: ItemResource) -> ItemStack:
	for stack in item_slots:
		if stack and stack.item == item:
			return stack
	
	return null


func count(item: ItemResource) -> int:
	var item_count := 0
	for stack in item_slots:
		if stack and stack.item == item:
			item_count += stack.amount
	
	return item_count


func contents(return_only_non_empty := true) -> Array:
	if not return_only_non_empty:
		return item_slots
	
	var item_stacks := [ ]
	for stack in item_slots:
		if stack:
			item_stacks.append(stack)
	
	return item_stacks


func size() -> int:
	return _inventory_attributes.inventory_size


func empty() -> bool:
	return contents(true).empty()



func _add_to_stack(item: ItemResource, count: int, stack: ItemStack) -> int:
	while count > 0 and stack.amount < item.stack_size:
		stack.amount += 1
		count -= 1
		emit_signal("item_added", item)
		if item is ToolResource:
			emit_signal("equipment_added", item)
	
	return count


# Return how many are left in the stack
func _remove_from_stack(item: ItemResource, count: int, slot: int) -> int:
	var stack: ItemStack = item_slots[slot]
	while count > 0 and stack.amount > 0:
		stack.amount -= 1
		count -= 1
		emit_signal("item_removed", item)
		if item is ToolResource:
			emit_signal("equipment_removed", item)
		
		if stack.amount <= 0:
			item_slots[slot] = null
			break
	
	return stack.amount


func _spawn_item(item: ItemResource) -> void:
	var center_position := _drop_area.global_transform.origin
	var size := _drop_shape.extents
	var spawn_position := center_position
	spawn_position.x += (randf() - 0.5) * size.x
	spawn_position.z += (randf() - 0.5) * size.z
	
	# warning-ignore:return_value_discarded
	item.drop_at(spawn_position)


func _on_died() -> void:
	drop_everything()


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not _inventory_attributes:
		warning = "InventoryAttributesResource is required"
	elif not _inventory_attributes is InventoryAttributesResource:
		warning = "InventoryAttributesResource is of the wrong type"
	
	return warning
