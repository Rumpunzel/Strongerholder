class_name CityStructure, "res://class_icons/structures/icon_city_structure.svg"
extends Structure


const PERSIST_PROPERTIES_3 := ["storage_resources", "input_resources", "_output_resources", "_production_steps", "_available_job"]


export(GDScript) var _available_job

# Defines what types of resources can be stored in this building
export(Array, Constants.Resources) var storage_resources = [ ]

# Defines behaviour of the refinery for this structure
#	if this structure is not supposed to refine anything, leave it empty
export(Array, Constants.Resources) var input_resources = [ ]
export(Array, Constants.Resources) var _output_resources = [ ]

export var _production_steps: int = 2




func assign_gatherer(puppet_master: Node2D, gathering_resource) -> void:
	_pilot_master.assign_gatherer(puppet_master, gathering_resource)

func unassign_gatherer(puppet_master: Node2D, gathering_resource) -> void:
	_pilot_master.unassign_gatherer(puppet_master, gathering_resource)

func can_be_gathered(gathering_resource, puppet_master: Node2D, is_employee: bool = false) -> bool:
	return _pilot_master.can_be_gathered(gathering_resource, puppet_master, is_employee)


func operate() -> void:
	_state_machine.operate()

func can_be_operated() -> bool:
	return _pilot_master.can_be_operated()


func has_how_many_of_item(item_type) -> Array:
	return _pilot_master.how_many_of_item(item_type)

func request_item(request, receiver: Node2D) -> void:
	var requested_item: Node2D = _pilot_master.has_item(request)
	
	if requested_item:
		_state_machine.give_item(requested_item, receiver)




func _initialise_pilot_master() -> void:
	_pilot_master = load("res://game_objects/structures/buildings/components/city_pilot_master.tscn").instance()
	_pilot_master.game_object = self
	_pilot_master.available_job = _available_job
	_pilot_master.storage_resources = storage_resources
	
	add_child(_pilot_master)
	
	_pilot_master._initialise_refineries(input_resources, _output_resources, _production_steps)
	connect("died", _pilot_master, "unregister_resource")
