class_name JobMachine, "res://assets/icons/icon_job_machine.svg"
extends StateMachine


var employer: Node2D
var employee: Node2D

var dedicated_tool: Spyglass




func _setup(new_employer: Node2D, new_employee: Node2D, new_dedicated_tool: Spyglass):
	employer = new_employer
	employee = new_employee
	
	dedicated_tool = new_dedicated_tool
	
	for state in get_children():
		state.employer = employer
		state.employee = employee
		
		state.dedicated_tool = dedicated_tool
	
	current_state.activate(true)




func next_step() -> Vector2:
	return current_state.next_step()

func next_command() -> InputMaster.Command:
	return current_state.next_command()

func current_target() -> Node2D:
	return current_state.current_target()



func activate():
	current_state.activate()

func deactivate():
	current_state.deactivate()
