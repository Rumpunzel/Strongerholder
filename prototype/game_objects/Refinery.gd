class_name Refinery, "res://assets/icons/icon_refinery.svg"
extends Inventory


export(NodePath) var _inventory_node

export(Array, Constants.Resources) var _input_resources
export(Array, Constants.Resources) var _output_resources
export var _process_time: float = 2.0


onready var _inventory: Inventory = get_node(_inventory_node)
onready var _process_timer: Timer = Timer.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	for resource in _input_resources:
		_inventory.requests.append(resource)
	
	_inventory.connect("received_item", self, "_check_item_viability")
	connect("received_item", self, "_check_item_numbers")
	_process_timer.connect("timeout", self, "_send_prodcut")


func initialize():
	.initialize()
	_process_timer.wait_time = _process_time
	_process_timer.one_shot = true
	add_child(_process_timer)




func _check_item_viability(new_item: int):
	if _process_timer.is_stopped():
		if _input_resources.has(new_item):
			_inventory.request_item(new_item, self)


func _check_item_numbers(_new_item = null):
	for item in contents:
		if not contents.count(item) == _input_resources.count(item):
			return
	
	_process_items()


func _process_items():
	_process_timer.start()


func _send_prodcut():
	for item in _input_resources:
		contents.erase(item)
	
	for item in _output_resources:
		contents.append(item)
		_send_item(item, _inventory)
	
	for item in _input_resources:
		_check_item_viability(item)
