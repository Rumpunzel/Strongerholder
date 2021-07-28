class_name Storage
extends Spatial

const SQUARE_SIZE := 2.0

export var x_extents := 2
export var z_extents := 2

var _stacks := [ ]



func _ready() -> void:
	_stacks.resize(x_extents * z_extents)
	for i in _stacks.size():
		_stacks[i] = StorageStack.new(null)



func _on_item_added(item: ItemResource) -> void:
	var index := 0
	var active_stack: StorageStack = null
	
	while index < _stacks.size():
		var stack: StorageStack = _stacks[index]
		if not stack.item_resource:
			stack.item_resource = item
		
		if stack.item_resource == item and not stack.full():
			active_stack = stack
			break
		
		index += 1
	
	
	var node := item.store_in(self, active_stack.size(), SQUARE_SIZE)
	node.transform.origin += Vector3(index % x_extents, 0.0, floor(index / float(z_extents))) * SQUARE_SIZE
	active_stack.push(node)


func _on_item_removed(item: ItemResource) -> void:
	pass



class StorageStack:
	var item_resource: ItemResource
	var items: Array
	
	func _init(new_item: ItemResource) -> void:
		item_resource = new_item
		items = [ ]
	
	func push(item: Spatial) -> void:
		items.push_back(item)
	
	func pop() -> void:
		var item: Spatial = items.pop_back()
		item.queue_free()
	
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
