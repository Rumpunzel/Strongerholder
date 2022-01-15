class_name StateMachine, "res://editor_tools/class_icons/nodes/icon_gears.svg"
extends Node
tool

export(Resource) var _transition_table_resource

var _current_state: State


func _ready() -> void:
	if _transition_table_resource and not _current_state:
		_start()

func _process(delta: float) -> void:
	if not _current_state:
		return
	
	var transition_state: State = _current_state.try_get_transition()
	
	if transition_state:
		assert(transition_state != _current_state)
		_transition(transition_state)
	
	_current_state.on_update(delta)


func _start() -> void:
	if Engine.editor_hint:
		return
	
	_current_state = _transition_table_resource.get_initial_state(self)
	_current_state.on_state_enter()


func _transition(transition_state: State) -> void:
	_current_state.on_state_exit()
	_current_state = transition_state
	_current_state.on_state_enter()


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not _transition_table_resource:
		warning = "TranstitionTableResource is required"
	elif not _transition_table_resource is TransitionTableResource:
		warning = "TranstitionTableResource is of the wrong type"
	
	return warning
