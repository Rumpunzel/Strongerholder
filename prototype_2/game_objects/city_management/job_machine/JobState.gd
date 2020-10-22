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


var game_actor: GameActor = null
var employer: CityStructure = null

var dedicated_tool: Spyglass = null


onready var _job_machine = get_parent()
onready var _navigator: Navigator = ServiceLocator.navigator



func enter(_parameters: Array = [ ]):
	set_process(true)


func exit(next_state: String, parameters: Array = [ ]):
	set_process(false)
	
	_job_machine._change_to(next_state, parameters)



func next_step() -> Vector2:
	return Vector2()


func next_command() -> InputMaster.Command:
	return InputMaster.Command.new()



func activate(first_time: bool = false):
	pass

func deactivate():
	exit(INACTIVE)


func is_active() -> bool:
	return true



func _get_nearest_item_of_type(item_type) -> Node2D:
	return _navigator.nearest_in_group(game_actor.global_position, item_type)
