class_name CityStructure, "res://assets/icons/structures/icon_city_structure.svg"
extends Structure


export(GDScript) var _available_job
export var _storage: bool = false

export(Array, Constants.Resources) var input_resources
export(Array, Constants.Resources) var _output_resources

export var _production_steps: int = 2



func assign_gatherer(puppet_master: Node2D, gathering_resource):
	_pilot_master.assign_gatherer(puppet_master, gathering_resource)

func unassign_gatherer(puppet_master: Node2D, gathering_resource):
	_pilot_master.unassign_gatherer(puppet_master, gathering_resource)

func can_be_gathered(gathering_resource) -> bool:
	return _pilot_master.can_be_gathered(gathering_resource)


func operate():
	_state_machine.operate()

func can_be_operated() -> bool:
	return _pilot_master.can_be_operated()


func request_item(request, receiver: Node2D):
	var requested_item: Node2D = _pilot_master.has_item(request)
	
	if requested_item:
		_state_machine.give_item(requested_item, receiver)



func _initliase_pilot_master():
	_pilot_master = load("res://game_objects/structures/buildings/city_pilot_master.tscn").instance()
	_pilot_master._available_job = _available_job
	_pilot_master._storage = _storage
	
	add_child(_pilot_master)
	
	_pilot_master._initialise_refineries(input_resources, _output_resources, _production_steps)
