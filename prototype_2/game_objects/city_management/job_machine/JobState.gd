class_name JobState, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends Node


const JUST_STARTED = "just_started"
const IDLE = "idle"
const DELIVER = "deliver"
const RETRIEVE = "retrieve"
const PICK_UP = "pick_up"
const GATHER = "gather"
const MOVE_TO = "move_to"
const OPERATE = "operate"
const INACTIVE = "inactive"


# warning-ignore-all:unused_class_variable
var employee: PuppetMaster = null
# warning-ignore-all:unused_class_variable
var employer: PilotMaster = null

# warning-ignore-all:unused_class_variable
var dedicated_tool: Spyglass = null


onready var _job_machine = get_parent()
onready var _navigator: Navigator = ServiceLocator.navigator
onready var _quarter_master = ServiceLocator.quarter_master




func _ready():
	set_process(false)


func _process(_delta: float):
	_check_for_exit_conditions()




func enter(_parameters: Array = [ ]):
	for item in _job_items():
		item.assign_worker(employee)
	
	set_process(true)


func exit(next_state: String, parameters: Array = [ ]):
	set_process(false)
	
	for item in _job_items():
		if weakref(item).get_ref():
			item.unassign_worker(employee)
	
	_job_machine._change_to(next_state, parameters)




func next_step() -> Vector2:
	return Vector2()


func next_command() -> InputMaster.Command:
	return InputMaster.Command.new()


func current_target() -> Node2D:
	return null



func activate(_first_time: bool = false):
	pass

func deactivate():
	exit(INACTIVE)


func is_active() -> bool:
	return true



func _check_for_exit_conditions():
	pass


func _job_items() -> Array:
	return employee._main_inventory.get_contents()


func _get_nearest_item_of_type(item_type) -> GameResource:
	return _quarter_master.inquire_for_resource(employee, item_type, true)

func _get_nearest_structure_holding_item_of_type(item_type, groups_to_exclude: Array) -> Structure:
	return _quarter_master.inquire_for_resource(employee, item_type, false, groups_to_exclude)
