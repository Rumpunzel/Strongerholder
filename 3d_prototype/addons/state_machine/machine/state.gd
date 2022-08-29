class_name State

var origin_resource: Resource
var state_machine#: StateMachine
var transitions: Array
var actions: Array



func _init(
		new_origin_resource: Resource,
		new_state_machine = null,#: StateMachine,
		new_transitions: Array = [ ],
		new_actions: Array = [ ]
) -> void:
	
	origin_resource = new_origin_resource
	state_machine = new_state_machine
	transitions = new_transitions
	actions = new_actions



func on_state_enter() -> void:
	for transition in transitions:
		transition.on_state_enter()
	
	for action in actions:
		action.on_state_enter()


func on_update(delta: float) -> void:
	for action in actions:
		action.on_update(delta)


func on_input(input: InputEvent) -> void:
	for action in actions:
		action.on_input(input)


func on_state_exit():
	for transition in transitions:
		transition.on_state_exit()
	
	for action in actions:
		action.on_state_exit()


func try_get_transition() -> State:
	var state: State = null
	
	for transition in transitions:
		state = transition.try_get_transition()
		if state:
			break
	
	return state


func _to_string() -> String:
	return "%s" % origin_resource
