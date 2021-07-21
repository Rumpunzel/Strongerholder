class_name Inventory, "res://editor_tools/class_icons/nodes/icon_swap_bag.svg"
extends Node
tool

signal item_added(item)
signal item_removed(item)

signal item_stack_added(item_stack)
signal item_stack_removed(item_stack)

signal equipment_added(equipment)
signal equipment_removed(equipment)

signal equipment_stack_added(equipment_stack)
signal equipment_stack_removed(equipment_stack)


export(Resource) var _inventory_attributes

var item_slots := [ ]

var _initialized := false



func _enter_tree() -> void:
	if Engine.editor_hint:
		return
	
	_initialize(_inventory_attributes.inventory_size)


func _ready() -> void:
	if Engine.editor_hint:
		return
	
	for item in _inventory_attributes.starting_items:
		# warning-ignore:return_value_discarded
		add(item)



# Returns how many items were dropped because the inventory was full
func add(item: ItemResource, count := 1) -> int:
	assert(count > 0)
	for slot in item_slots.size():
		var stack: ItemStack = item_slots[slot]
		if stack.item:
			if item == stack.item:
				count = _add_to_stack(item, count, stack)
				if count <= 0:
					break
		else:
			stack.item = item
			emit_signal("item_stack_added", stack)
			if item is ToolResource:
				emit_signal("equipment_stack_added", stack)
			
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
			left_in_stack = _remove_from_stack(stack, 1)
			break
	
	return left_in_stack


# Returns how many are left in the stack
func use(item: ItemResource) -> int:
	var left_in_stack := -1
	for slot in item_slots.size():
		var stack: ItemStack = item_slots[slot]
		if stack and stack.item == item:
			left_in_stack = _remove_from_stack(stack, 1)
			break
	
	if left_in_stack < 0:
		printerr("Tried to use [ %s ] from %s but there were none in inventory." % [ item, owner.name ])
		return left_in_stack
	
	item.use()
	return left_in_stack


# Returns how many are left in the stack
func use_item_from_stack(stack: ItemStack) -> int:
	if stack.amount <= 0:
		printerr("Tried to use [ %s ] from %s but there were none in inventory." % [ stack.item, owner.name ])
		return stack.amount
	
	stack.item.use()
	return _remove_from_stack(stack, 1)


# Returns how many are left in the stack
func drop(item: ItemResource) -> int:
	var left_in_stack := -1
	for slot in item_slots.size():
		var stack: ItemStack = item_slots[slot]
		if stack and stack.item == item:
			left_in_stack = _remove_from_stack(stack, 1)
			break
	
	if left_in_stack < 0:
		printerr("Tried to drop [ %s ] from %s but there were none in inventory." % [ item, owner.name ])
		return left_in_stack
	
	_spawn_item(item)
	return left_in_stack


# Returns how many are left in the stack
func drop_item_from_stack(stack: ItemStack) -> int:
	if stack.amount <= 0:
		printerr("Tried to drop [ %s ] from %s but there were none in inventory." % [ stack.item, owner.name ])
		return stack.amount
	
	_spawn_item(stack.item)
	return _remove_from_stack(stack, 1)


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
		if stack and stack.item:
			item_stacks.append(stack)
	
	return item_stacks


func size() -> int:
	return _inventory_attributes.inventory_size


func empty() -> bool:
	return contents().empty()

func full(specific_item_to_check: ItemResource = null) -> bool:
	for slot in item_slots.size():
		var stack: ItemStack = item_slots[slot]
		if not stack.item or (stack.item == specific_item_to_check and stack.amount < stack.item.stack_size):
			return false
	
	return true



func save_to_var(save_file: File) -> void:
	# Store item_slots size
	save_file.store_8(item_slots.size())
	for stack in item_slots:
		# Store as data
		stack.save_to_var(save_file)

func load_from_var(save_file: File) -> void:
	# Resize array
	_initialize(save_file.get_8())
	for stack in item_slots:
		# Load as data
		stack.load_from_var(save_file)



func _initialize(size: int) -> void:
	if _initialized:
		return
	
	item_slots.resize(size)
	for slot in item_slots.size():
		item_slots[slot] = ItemStack.new(null)
	
	_initialized = true


func _add_to_stack(item: ItemResource, count: int, stack: ItemStack) -> int:
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore-all:unsafe_property_access
	while count > 0 and stack.amount < item.stack_size:
		stack.amount += 1
		count -= 1
		emit_signal("item_added", item)
		
		if item is ToolResource:
			emit_signal("equipment_added", item)
	
	return count


# Returns how many are left in the stack
func _remove_from_stack(stack: ItemStack, count: int) -> int:
	while count > 0 and stack.amount > 0:
		stack.amount -= 1
		count -= 1
		emit_signal("item_removed", stack.item)
		
		if stack.item is ToolResource:
			emit_signal("equipment_removed", stack.item)
		
		if stack.amount <= 0:
			emit_signal("item_stack_removed", stack)
			
			if stack.item is ToolResource:
				emit_signal("equipment_stack_removed", stack)
			
			stack.reset()
			break
	
	return stack.amount


func _spawn_item(item: ItemResource) -> void:
	var spawn_position: Vector3 = owner.translation + Vector3((randf() - 0.5) * 5.0, 2.0, (randf() - 0.5) * 5.0)
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




class ItemStack extends Reference:
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
		save_file.store_8(amount)
	
	func load_from_var(save_file: File) -> void:
		# Load as resource
		var loaded_item: ItemResource = null
		var stored_item = save_file.get_var()
		if stored_item:
			loaded_item = load(stored_item)
		
		item = loaded_item
		amount = save_file.get_8()
	
	func _to_string() -> String:
		return "Item: [ %s ], Amount: %d" % [ item, amount ]
