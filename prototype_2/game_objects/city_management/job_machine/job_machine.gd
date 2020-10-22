class_name JobMachine, "res://assets/icons/icon_job_machine.svg"
extends StateMachine


var employer: Node2D
var employee: Node2D

var dedicated_tool: Spyglass




func _pre_setup(new_employer: Node2D, new_dedicated_tool: Spyglass):
	employer = new_employer
	
	dedicated_tool = new_dedicated_tool
	
	for state in get_children():
		state.employer = employer
		state.dedicated_tool = dedicated_tool


func _setup(new_employee: Node2D):
	employee = new_employee
	
	for state in get_children():
		state.game_actor = employee
	
	current_state.activate(true)




func next_step() -> Vector2:
	return current_state.next_step()



func activate():
	current_state.activate()

func dectivate():
	current_state.deactivate()
