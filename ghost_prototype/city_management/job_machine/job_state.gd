class_name JobState, "res://class_icons/states/icon_state_idle.svg"
extends State


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := [ "name" ]


signal items_assigned
# warning-ignore:unused_signal
signal gatherer_assigned
# warning-ignore:unused_signal
signal gatherer_unassigned
# warning-ignore:unused_signal
signal worker_assigned
# warning-ignore:unused_signal
signal worker_unassigned



const JUST_STARTED := "JustStarted"
const IDLE := "Idle"
const DELIVER := "Deliver"
const RETRIEVE := "Retrieve"
const PICK_UP := "PickUp"
const GATHER := "Gather"
const MOVE_TO := "MoveTo"
const OPERATE := "Operate"
const INACTIVE := "Inactive"


onready var _quarter_master = ServiceLocator.quarter_master




func check_for_exit_conditions(_employee: PuppetMaster, _employer: CityStructure, _dedicated_tool: Spyglass) -> void:
	pass



func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("items_assigned")




func next_step(_start_position: Vector2) -> Vector2:
	return Vector2()


func next_command(_employee: PuppetMaster, _dedicated_tool: Spyglass) -> InputMaster.Command:
	return InputMaster.Command.new()


func current_target() -> GameObject:
	return null



func activate(_first_time: bool = false, _parameters: Array = [ ]) -> void:
	assert(false, "already active")

func deactivate() -> void:
	exit(INACTIVE)


func is_active() -> bool:
	return true



func _get_nearest_item_of_type(employee: PuppetMaster, item_type: String) -> GameResource:
	return _quarter_master.inquire_for_resource(employee, item_type, true)

func _get_nearest_structure_holding_item_of_type(employee: PuppetMaster, item_type: String, groups_to_exclude: Array) -> Structure:
	return _quarter_master.inquire_for_resource(employee, item_type, false, groups_to_exclude)
