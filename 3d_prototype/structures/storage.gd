class_name Storage
extends Spatial

const SQUARE_SIZE := 2.0

enum CommandType { PUSH = 1, POP }

export var x_extents := 2
export var z_extents := 2

export var _max_animation_time := 0.5

var _stacks := [ ]
var _stacks_for_resources := { }
var _command_queue := [ ]

onready var _inventory: Inventory = Utils.find_node_of_type_in_children(owner, Inventory)
onready var _tick_timer: Timer = Timer.new()



func _ready() -> void:
	_stacks.resize(x_extents * z_extents)
	for i in _stacks.size():
		_stacks[i] = StorageStack.new(null)
	
	# warning-ignore:return_value_discarded
	_inventory.connect("item_added", self, "_on_item_added")
	# warning-ignore:return_value_discarded
	_inventory.connect("item_removed", self, "_on_item_removed")
	
	# warning-ignore:return_value_discarded
	_tick_timer.connect("timeout", self, "_parse_command")
	add_child(_tick_timer)



func _add_item(item: ItemResource) -> void:
	var index := 0
	var active_stack: StorageStack = null
	
	var resource_stacks: Array = _stacks_for_resources.get(item, [ ])
	for stack in resource_stacks:
		if not stack.full():
			active_stack = stack
			index = _stacks.find(active_stack)
			break
	
	while not active_stack and index < _stacks.size():
		var stack: StorageStack = _stacks[index]
		if not stack.item_resource:
			stack.item_resource = item
			_stacks_for_resources[item] = _stacks_for_resources.get(item, [ ])
			_stacks_for_resources[item].append(stack)
		
		if stack.item_resource == item and not stack.full():
			active_stack = stack
			break
		
		index += 1
	
	
	var x_index := index % x_extents
	var z_index := int(index / float(z_extents))
	var stack_rotated := x_index % 2 == 1
	if z_index % 2 == 1:
		stack_rotated = not stack_rotated
	
	var node := item.store_in(self, active_stack.size(), stack_rotated, SQUARE_SIZE)
	
	node.transform.origin += Vector3(x_index - x_extents * 0.5, 0.0, z_index - z_extents * 0.5) * SQUARE_SIZE
	active_stack.push(node)


func _remove_item(item: ItemResource) -> void:
	for stack in _stacks:
		if stack.item_resource == item:
			var deleted: bool = not stack.pop()
			if deleted:
				_stacks_for_resources[item].erase(stack)
			break



func _on_item_added(item: ItemResource) -> void:
	if get_tree().paused:
		_add_item(item)
	else:
		_command_queue.push_back(Command.new(item, CommandType.PUSH))
		_tick_timer.start(_max_animation_time / float(_command_queue.size()))

func _on_item_removed(item: ItemResource) -> void:
	if get_tree().paused:
		_remove_item(item)
	else:
		_command_queue.push_back(Command.new(item, CommandType.POP))
		_tick_timer.start(_max_animation_time / float(_command_queue.size()))


func _parse_command() -> void:
	var command: Command = _command_queue.pop_front()
	if _command_queue.empty():
		_tick_timer.stop()
	match command.type:
		CommandType.PUSH:
			_add_item(command.item)
		CommandType.POP:
			_remove_item(command.item)
		_:
			assert(false)



class StorageStack:
	var item_resource: ItemResource
	var items: Array
	
	func _init(new_item: ItemResource) -> void:
		item_resource = new_item
		items = [ ]
	
	func push(item: Spatial) -> void:
		items.push_back(item)
	
	func pop() -> bool:
		var item: Spatial = items.pop_back()
		item.queue_free()
		if items.empty():
			item_resource = null
			return false
		return true
	
	func size() -> int:
		return items.size()
	
	func stack_size() -> int:
		# WAITFORUPDATE: remove this unnecessary thing after 4.0
		# warning-ignore:unsafe_property_access
		return item_resource.stockpile_stack_attributes.stack_size()
	
	func full() -> bool:
		return items.size() >= stack_size()
	
	func reset() -> void:
		item_resource = null
		assert(items.empty())
		items.clear()



class Command:
	var item: ItemResource
	var type: int
	
	func _init(new_item: ItemResource, new_type: int) -> void:
		item = new_item
		type = new_type
