class_name Refinery, "res://assets/icons/structures/icon_refinery.svg"
extends Inventory


export(NodePath) var _inventory_node

export(Array, String) var _input_resources
export(Array, PackedScene) var _output_resources
export var _process_time: float = 2.0


onready var _inventory: Inventory = get_node(_inventory_node)
onready var _process_timer: Timer = Timer.new()




# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: THIS IS A DUMB ASS FIX FOR EXPORTED ARRAYS BEING SHARED BETWEEN ALL INSTANCES OF CLASSES PLEASE DO NOT SHIP!
	_inventory.requests.clear()
	
	for resource in _input_resources:
		_inventory.requests.append(resource)
	
	_inventory.connect("received_item", self, "_check_item_viability")
	connect("received_item", self, "_check_item_numbers")
	_process_timer.connect("timeout", self, "_send_prodcut")


func initialize():
	_process_timer.wait_time = _process_time
	_process_timer.one_shot = true
	add_child(_process_timer)




func _check_item_viability(new_item):
	if _process_timer.is_stopped():
		if new_item is GameResource:
			new_item = new_item.type
		
		if _input_resources.has(new_item):
			_inventory.request_item(new_item, self)


func _check_item_numbers(_new_item = null):
	var content: Dictionary = { }
	
	for item in get_children():
		if item is GameResource:
			content[item.type] = content.get(item.type, 0) + 1
	
	for item in _input_resources:
		if not content.get(item, 0) >= _input_resources.count(item):
			return
	
	_process_items()


func _process_items():
	_process_timer.start()


func _send_prodcut():
	for item in _input_resources:
		for resource in get_children():
			if resource is GameResource and resource.type == item:
				remove_child(resource)
				resource.queue_free()
				break
	
	for item in _output_resources:
		var new_item: GameResource = item.instance()
		
		add_child(new_item)
		new_item._setup(owner.ring_vector)
		_send_item(new_item, _inventory)
	
	for item in _input_resources:
		_check_item_viability(item)
