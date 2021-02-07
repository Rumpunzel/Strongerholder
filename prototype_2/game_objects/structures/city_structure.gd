class_name CityStructure, "res://class_icons/game_objects/structures/icon_city_structure.svg"
extends Structure


const SCENE_OVERRIDE := "res://game_objects/structures/city_structure.tscn"

const PERSIST_PROPERTIES_3 := [ "storage_resources", "input_resources", "output_resources", "production_steps" ]


# Defines what types of resources can be stored in this building
var storage_resources := { }

# Defines behaviour of the refinery for this structure
#	if this structure is not supposed to refine anything, leave it empty
var input_resources := { }
var output_resources := { }

var production_steps: int = 2


var _available_job: GDScript = load("res://city_management/job_machine/job_machine.gd") as GDScript




func assign_gatherer(puppet_master: Node2D, gathering_resource) -> void:
	(_pilot_master as CityPilotMaster).assign_gatherer(puppet_master, gathering_resource)

func unassign_gatherer(puppet_master: Node2D, gathering_resource) -> void:
	(_pilot_master as CityPilotMaster).unassign_gatherer(puppet_master, gathering_resource)

func can_be_gathered(gathering_resource, puppet_master: Node2D, is_employee: bool = false) -> bool:
	return (_pilot_master as CityPilotMaster).can_be_gathered(gathering_resource, puppet_master, is_employee)


func operate() -> void:
	(_state_machine as StructureStateMachine).operate()

func can_be_operated() -> bool:
	return (_pilot_master as CityPilotMaster).can_be_operated()


func request_item(request: String, reciever: Node2D) -> void:
	var item: GameResource = _pilot_master.has_item(request)
	
	if item and _pilot_master.in_range(reciever):
		(_state_machine as StructureStateMachine).give_item(item, reciever)



func _initialise_pilot_master(new_pilot_master: PackedScene = load("res://game_objects/structures/components/city_pilot_master.tscn") as PackedScene) -> void:
	._initialise_pilot_master(new_pilot_master)
	
	(_pilot_master as CityPilotMaster).available_job = _available_job
	(_pilot_master as CityPilotMaster).storage_resources = storage_resources
	
	(_pilot_master as CityPilotMaster)._initialise_refineries(input_resources, output_resources, production_steps)
