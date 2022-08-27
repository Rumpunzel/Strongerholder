class_name StateMachine, "res://addons/state_machine/icons/icon_gears.svg"
extends Node
tool

export var use_physics_process := false
export(Resource) var _transition_table_resource

var _current_state: State


func _ready() -> void:
	set_process(not use_physics_process)
	set_physics_process(use_physics_process)
	if _transition_table_resource and not _current_state:
		_start()

func _process(delta: float) -> void:
	_on_process(delta)

func _physics_process(delta: float) -> void:
	_on_process(delta)


func _start() -> void:
	if Engine.editor_hint:
		return
	
	_current_state = _transition_table_resource.initialize(self)
	_current_state.on_state_enter()

func _on_process(delta: float) -> void:
	if not _current_state:
		return
	
	var transition_state: State = _current_state.try_get_transition()
	if transition_state:
		assert(transition_state != _current_state)
		_transition(transition_state)
	_current_state.on_update(delta)

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
