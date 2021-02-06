class_name CityStructure, "res://class_icons/game_objects/structures/icon_city_structure.svg"
extends Structure


const SCENE_OVERRIDE := "res://game_objects/structures/city_structure.tscn"

const PERSIST_PROPERTIES_3 := ["storage_resources", "input_resources", "output_resources", "production_steps", "_available_job"]


# Defines what types of resources can be stored in this building
var storage_resources := { }

# Defines behaviour of the refinery for this structure
#	if this structure is not supposed to refine anything, leave it empty
var input_resources := { }
var output_resources := { }

var production_steps: int = 2


var _available_job := load("res://city_management/job_machine/job_machine.gd")




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



func _initialise_pilot_master(new_pilot_master := load("res://game_objects/structures/components/city_pilot_master.tscn")) -> void:
	._initialise_pilot_master(new_pilot_master)
	
	_pilot_master.available_job = _available_job
	_pilot_master.storage_resources = storage_resources
	
	_pilot_master._initialise_refineries(input_resources, output_resources, production_steps)
