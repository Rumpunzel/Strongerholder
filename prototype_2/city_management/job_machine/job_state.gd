class_name JobState, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name"]
const PERSIST_OBJ_PROPERTIES := ["job_machine", "employee", "employer", "employer_structure", "dedicated_tool"]


const JUST_STARTED = "just_started"
const IDLE = "idle"
const DELIVER = "deliver"
const RETRIEVE = "retrieve"
const PICK_UP = "pick_up"
const GATHER = "gather"
const MOVE_TO = "move_to"
const OPERATE = "operate"
const INACTIVE = "inactive"


var job_machine = null
# warning-ignore-all:unused_class_variable
var employee: PuppetMaster = null
# warning-ignore-all:unused_class_variable
var employer: PilotMaster = null
var employer_structure: CityStructure = null

# warning-ignore-all:unused_class_variable
var dedicated_tool: Spyglass = null

var _update_time: float = 0.5
var _timed_passed: float = 0.0


onready var _navigator: Navigator = ServiceLocator.navigator
onready var _quarter_master = ServiceLocator.quarter_master




func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	_timed_passed += delta
	
	if _timed_passed < _update_time:
		return
	
	_timed_passed = 0.0
	
	_check_for_exit_conditions()




func enter(_parameters: Array = [ ]) -> void:
	for item in _job_items():
		item.assign_worker(employee)
	
	set_process(true)


func exit(next_state: String, parameters: Array = [ ]) -> void:
	set_process(false)
	
	_timed_passed = 0.0
	
	for item in _job_items():
		if weakref(item).get_ref():
			item.unassign_worker(employee)
	
	job_machine._change_to(next_state, parameters)




func next_step() -> Vector2:
	return Vector2()


func next_command() -> InputMaster.Command:
	return InputMaster.Command.new()


func current_target() -> Node2D:
	return null



func activate(_first_time: bool = false, _tool_type = null) -> void:
	pass

func deactivate() -> void:
	exit(INACTIVE)


func is_active() -> bool:
	return true



func _check_for_exit_conditions() -> void:
	pass


func _job_items() -> Array:
	return employee.get_inventory_contents(true)


func _get_nearest_item_of_type(item_type) -> GameResource:
	return _quarter_master.inquire_for_resource(employee, item_type, true)

func _get_nearest_structure_holding_item_of_type(item_type, groups_to_exclude: Array) -> Structure:
	return _quarter_master.inquire_for_resource(employee, item_type, false, groups_to_exclude)
