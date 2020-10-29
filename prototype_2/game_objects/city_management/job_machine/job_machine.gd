class_name JobMachine, "res://assets/icons/icon_job_machine.svg"
extends StateMachine


const PERSIST_OBJ_PROPERTIES_2 := ["employer", "employee", "dedicated_tool", "_debug_flag_scene", "_flag"]


const _debug_flag_scene = preload("res://flag.tscn")


var employer: Node2D
var employee: Node2D

var dedicated_tool: Spyglass


var _flag: Sprite




func _setup_states(state_classes: Array = [ ]):
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


func _ready():
	for state in get_children():
		state.employer = employer
		state.employee = employee
		
		state.dedicated_tool = dedicated_tool
	
	if not _flag and _debug_flag_scene:
		_flag = _debug_flag_scene.instance()
	
	get_tree().current_scene.add_child(_flag)


func _setup(new_employer: Node2D, new_employee: Node2D, new_dedicated_tool: Spyglass):
	employer = new_employer
	employee = new_employee
	
	dedicated_tool = new_dedicated_tool
	
	for state in get_children():
		state.employer = employer
		state.employee = employee
		
		state.dedicated_tool = dedicated_tool
	
	_flag.target = employee


func _process(_delta):
	yield(get_tree(), "idle_frame")
	
	var target: Node2D = current_target()
	
	if target:
		_flag.visible = true
		_flag.global_position = target.global_position
	else:
		_flag.visible = false




func next_step() -> Vector2:
	if not current_state:
		return Vector2()
	
	return current_state.next_step()

func next_command() -> InputMaster.Command:
	if not current_state:
		return InputMaster.Command.new()
	
	return current_state.next_command()

func current_target() -> Node2D:
	if not current_state:
		return null
	
	return current_state.current_target()



func activate(first_time: bool = false):
	if not current_state:
		return null
	
	current_state.activate(first_time)

func deactivate():
	if not current_state:
		return null
	
	current_state.deactivate()
