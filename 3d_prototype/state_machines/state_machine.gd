class_name StateMachine
extends Node


export(Resource) var _transition_table_resource


var _current_state: State



func _ready():
	_current_state = _transition_table_resource.get_initial_state(self)
	
	_current_state.on_state_enter()


func _process(delta: float):
	var transition_state: State = _current_state.try_get_transition()
	
	if transition_state:
		assert(not (transition_state == _current_state))
		_transition(transition_state)
	
	_current_state.on_update(delta)



func _transition(transition_state: State) -> void:
	_current_state.on_state_exit()
	_current_state = transition_state
	_current_state.on_state_enter()
