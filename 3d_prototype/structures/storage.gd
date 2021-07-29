class_name Storage
extends Spatial

const SQUARE_SIZE := 2.0

export var x_extents := 2
export var z_extents := 2

export var _queue_interval := 0.1

var _stacks := [ ]
var _stacks_for_resources := { }

var _command_queue := [ ]
var _queue_ticker := 0.0

onready var _inventory: Inventory = Utils.find_node_of_type_in_children(owner, Inventory)



func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	_stacks.resize(x_extents * z_extents)
	for i in _stacks.size():
		_stacks[i] = StorageStack.new(null)
	
	# warning-ignore:return_value_discarded
	_inventory.connect("item_added", self, "_on_item_added")
	# warning-ignore:return_value_discarded
	_inventory.connect("item_removed", self, "_on_item_removed")


func _process(delta: float) -> void:
	_queue_ticker = min(_queue_ticker + delta, _queue_interval)
	
	if not _command_queue.empty() and (get_tree().paused or _queue_ticker >= _queue_interval):
		_queue_ticker = 0.0
		var command: Command = _command_queue.pop_front()
		command.execute()



func _on_item_added(item: ItemResource) -> void:
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
	
	
	_command_queue.push_back(PushCommand.new(active_stack, item, self, index, x_extents, z_extents))


func _on_item_removed(item: ItemResource) -> void:
	for stack in _stacks:
		if stack.item_resource == item:
			_command_queue.push_back(PopCommand.new(stack, _stacks_for_resources, item))
			break




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
	var _stack: StorageStack
	
	func _init(stack: StorageStack) -> void:
		_stack = stack
	
	func execute() -> void:
		assert(false)


class PushCommand extends Command:
	var _item: ItemResource
	var _storage: Spatial
	var _index: int
	var _x_extents: int
	var _z_extents: int
	
	func _init(stack: StorageStack, item: ItemResource, storage: Spatial, index: int, x_extents: int, z_extents: int).(stack) -> void:
		_item = item
		_storage = storage
		_index = index
		_x_extents = x_extents
		_z_extents = z_extents
	
	func execute() -> void:
		var node := _item.store_in(_storage, _stack.size(), SQUARE_SIZE)
		node.transform.origin += Vector3((_index % _x_extents) - 1.0, 0.0, floor(_index / float(_z_extents)) - 1.0) * SQUARE_SIZE
		_stack.push(node)


class PopCommand extends Command:
	var _stacks_for_resources: Dictionary
	var _item: ItemResource
	
	func _init(stack: StorageStack, stacks_for_resources: Dictionary, item: ItemResource).(stack) -> void:
		_stacks_for_resources = stacks_for_resources
		_item = item
	
	func execute() -> void:
		var deleted: bool = not _stack.pop()
		if deleted:
			_stacks_for_resources[_item].erase(_stack)
