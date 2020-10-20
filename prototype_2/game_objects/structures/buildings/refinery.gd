class_name Refinery, "res://assets/icons/structures/icon_refinery.svg"
extends Inventory


export(NodePath) var _inventory_node


export(Array, Constants.Resources) var input_resources


export(Array, PackedScene) var _output_resources
export var _process_time: float = 2.0


onready var _inventory: Inventory = get_node(_inventory_node)
onready var _process_timer: Timer = Timer.new()




# Called when the node enters the scene tree for the first time.
func _ready():
	_inventory.connect("received_item", self, "_check_item_viability")
	connect("received_item", self, "_check_item_numbers")
	
	_process_timer.wait_time = _process_time
	_process_timer.one_shot = true
	get_parent().call_deferred("add_child", _process_timer)
	_process_timer.name = "%s_process_timer" % [name]
	_process_timer.connect("timeout", self, "_send_prodcut")




func _check_item_viability(new_item: Node2D):
	if not _process_timer.is_stopped():
		return
	
	if input_resources.has(new_item.type):
		_inventory.drop_item(new_item, global_position)


func _check_item_numbers(_new_item: Node2D = null):
	var content: Dictionary = { }
	
	for item in get_contents():
		content[item.type] = content.get(item.type, 0) + 1
	
	for item in input_resources:
		if not content.get(item, 0) >= input_resources.count(item):
			return
	
	_process_items()


func _process_items():
	_process_timer.start()


func _send_prodcut():
	for item in input_resources:
		for resource in get_children():
			if resource is GameResource and resource.type == item:
				remove_child(resource)
				resource.queue_free()
				break
	
	for item in _output_resources:
		var new_item: GameResource = item.instance()
		
		add_child(new_item)
		drop_item(new_item, global_position)
	
	_check_item_numbers()
