extends Node
tool

export(Resource) var _transition_table

var _current_state: StateNode


func _ready() -> void:
	if Engine.editor_hint or not _transition_table or _current_state:
		return
	
	_current_state = _transition_table.initialize(self)
	_current_state.on_state_enter()

func _physics_process(delta: float) -> void:
	if Engine.editor_hint or not _current_state:
		return
	
	var transition_state_node_path: NodePath = _current_state.try_get_transition()
	if not transition_state_node_path.is_empty():
		var transition_state: StateNode = get_node(transition_state_node_path)
		assert(transition_state != _current_state)
		_current_state.on_state_exit()
		_current_state = transition_state
		_current_state.on_state_enter()
	
	_current_state.on_update(delta)
	
	$CurrentState.text = _current_state.name


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not _transition_table:
		warning = "TransitionTable is required"
	elif not _transition_table is TransitionTable:
		warning = "TransitionTable is of the wrong type"
	
	return warning
