class_name JobMachine, "res://class_icons/icon_job_machine.svg"
extends StateMachine


const PERSIST_PROPERTIES_2 := ["_debug_flag_scene"]
const PERSIST_OBJ_PROPERTIES_2 := ["employer", "employer_structure", "employee", "dedicated_tool", "_flag"]


const DebugFlagScene = preload("res://city_management/job_machine/flag.tscn")


var employer: Node2D
var employer_structure: Node2D
var employee: Node2D

var dedicated_tool: Spyglass setget set_dedicated_tool


var _flag: Sprite




func _setup_states(state_classes: Array = [ ]) -> void:
	if state_classes.empty():
		state_classes = [
			JobStateInactive,
			JobStateJustStarted, 
			JobStateIdle,
			JobStateRetrieve,
			JobStatePickUp,
			JobStateDeliver,
			JobStateGather,
			JobStateOperate,
			JobStateMoveTo,
		]
	
	._setup_states(state_classes)


func _ready() -> void:
#	for state in get_children():
#		state.employer = employer
#		state.employee = employee
	
	if not _flag and DebugFlagScene:
		_flag = DebugFlagScene.instance()
		get_tree().current_scene.add_child(_flag)


func _setup(new_employer: Node2D, new_employer_structure: Node2D, new_employee: Node2D) -> void:
	employer = new_employer
	employer_structure = new_employer_structure
	employee = new_employee
	
	for state in get_children():
		state.job_machine = self
		state.employer = employer
		state.employer_structure = employer_structure
		state.employee = employee
	
	_flag.target = employee


func _process(_delta) -> void:
	yield(get_tree(), "idle_frame")
	
	var target: Node2D = current_target()
	
	if target:
		_flag.visible = true
		_flag.global_position = target.global_position
	else:
		_flag.visible = false




func next_step() -> Vector2:
	return current_state.next_step()

func next_command() -> InputMaster.Command:
	return current_state.next_command()

func current_target() -> Node2D:
	return current_state.current_target()



func activate(first_time: bool = false, tool_type = null) -> void:
	current_state.activate(first_time, tool_type)

func deactivate() -> void:
	current_state.deactivate()



func set_dedicated_tool(new_tool: Spyglass) -> void:
	dedicated_tool = new_tool
	assert(dedicated_tool)
	
	for state in get_children():
		state.dedicated_tool = dedicated_tool
