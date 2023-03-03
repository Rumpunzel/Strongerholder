class_name StateMachine2, "res://addons/state_machine/icons/icon_gears.svg"
extends Node
tool

enum { CONDITIONS, RESULT_GROUPS }

export(NodePath) var entry_state
export(Array, Resource) var _transitions
# warning-ignore:unused_class_variable
export var _graph_offsets := { }

var _current_state: StateNode


func _ready() -> void:
	if Engine.editor_hint:
		return
	if _current_state:
		printerr("StateMachine tried to start but already had a current state!")
		return
	
	var problems := _verify_table()
	assert(problems.empty(), "TransitionTableResource has %d %s!" % [ problems.size(), "problem" if problems.size() == 1 else "problems" ])
	var created_instances := { }
	var transitions_for_states := { } # (StateNodePath) -> [ TransitionItem ]
	
	for transition_item in _transitions:
		for from_state_node_path in transition_item.from_states:
			transitions_for_states[from_state_node_path] = transitions_for_states.get(from_state_node_path, [ ])
			transitions_for_states[from_state_node_path].append(transition_item)
	
	for state_node_path in transitions_for_states.keys():
		var transitions := [ ]
		var state_node: StateNode = get_node(state_node_path)
		if state_node_path == entry_state:
			_current_state = state_node
		
		for transition_item in transitions_for_states[state_node_path]:
			var to_state: NodePath = transition_item.to_state
			var result_dic := _proccess_condition_usages(transition_item.conditions, transition_item.operator, created_instances)
			var conditions: Array = result_dic[CONDITIONS]
			var result_groups: Array = result_dic[RESULT_GROUPS]
			transitions.append(StateNodeTransition.new(to_state, conditions, result_groups))
		
		state_node.transitions = transitions
	
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
	
	# warning-ignore:unsafe_property_access
	$CurrentState.text = _current_state.name


func get_states_list() -> Array:
	var states_list := [ ]
	for child in get_children():
		if child is StateNode:
			states_list.append(child.name)
	return states_list


func _proccess_condition_usages(
	condition_usages: Array,
	operator: int,
	created_instances: Dictionary
) -> Dictionary:
	
	var count := condition_usages.size()
	var conditions: Array = [ ]
	var result_groups: Array = [ ]
	conditions.resize(count)
	
	for i in range(count):
		var usage: ConditionUsageResource = condition_usages[i]
		conditions[i] = usage.condition.get_condition(self, usage.expected_result, created_instances)
		
		var result_count := 1
		while i < count - 1 and operator == TransitionItem.Operator.AND:
			i += 1
			result_count += 1
		
		result_groups.append(result_count)
	
	return { CONDITIONS: conditions, RESULT_GROUPS: result_groups }


func _verify_table() -> Array: # [ Resource ]
	var problems := [ ]
	if not entry_state:
		if not problems.has(self):
			problems.append(self)
		printerr("StateMachine has no entry_state!")
	
	if _transitions.empty():
		if not problems.has(self):
			problems.append(self)
		printerr("StateMachine has no TransitionItems!")
	
	for transition in _transitions:
		if transition.from_states.empty():
			if not problems.has(transition):
				problems.append(transition)
			printerr("TransitionItem in has no from_states!")
		
		if not transition.to_state:
			if not problems.has(transition):
				problems.append(transition)
			printerr("TransitionItem in has no to_state!")
		
		for neighbor_transition in _transitions:
			if transition.from_states.has(neighbor_transition.to_state):
				for condition_usage in transition.conditions:
					for neighbor_condition_usage in neighbor_transition.conditions:
						if condition_usage.condition == neighbor_condition_usage.condition and condition_usage.expected_result == neighbor_condition_usage.expected_result:
							if not problems.has(condition_usage):
								problems.append(condition_usage)
							if not problems.has(neighbor_condition_usage):
								problems.append(neighbor_condition_usage)
							printerr("The State <%s> is skipped and potentially a loop!"  % [ neighbor_transition.to_state ])
			
			if neighbor_transition.from_states.has(transition.to_state):
				for condition_usage in transition.conditions:
					for neighbor_condition_usage in neighbor_transition.conditions:
						if condition_usage.condition == neighbor_condition_usage.condition and condition_usage.expected_result == neighbor_condition_usage.expected_result:
							if not problems.has(condition_usage):
								problems.append(condition_usage)
							if not problems.has(neighbor_condition_usage):
								problems.append(neighbor_condition_usage)
							printerr("The State <%s> is skipped and potentially a loop!"  % [ transition.to_state ])
	
	return problems
