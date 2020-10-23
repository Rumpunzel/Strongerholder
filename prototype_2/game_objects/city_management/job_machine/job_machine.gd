class_name JobMachine, "res://assets/icons/icon_job_machine.svg"
extends StateMachine


export(PackedScene) var _debug_flag_scene


var employer: Node2D
var employee: Node2D

var dedicated_tool: Spyglass


var _flag: Sprite




func _setup(new_employer: Node2D, new_employee: Node2D, new_dedicated_tool: Spyglass):
	employer = new_employer
	employee = new_employee
	
	dedicated_tool = new_dedicated_tool
	
	for state in get_children():
		state.employer = employer
		state.employee = employee
		
		state.dedicated_tool = dedicated_tool
	
	_flag = _debug_flag_scene.instance()
	get_tree().current_scene.add_child(_flag)
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
	return current_state.next_step()

func next_command() -> InputMaster.Command:
	return current_state.next_command()

func current_target() -> Node2D:
	return current_state.current_target()



func activate(first_time: bool = false):
	current_state.activate(first_time)

func deactivate():
	current_state.deactivate()
