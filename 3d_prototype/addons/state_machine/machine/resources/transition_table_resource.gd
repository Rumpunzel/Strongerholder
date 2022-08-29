class_name TransitionTableResource, "res://addons/state_machine/icons/icon_notebook.svg"
extends Resource
tool

enum { CONDITIONS, RESULT_GROUPS }

export(Resource) var entry_state_resource

export(Array, Resource) var _transitions
export var _graph_offsets := { }


func initialize(state_machine) -> State:# StateMachine) -> State:
	var problems := verify_table()
	assert(problems.empty(), "TransitionTableResource has %d %s!" % [ problems.size(), "problem" if problems.size() == 1 else "problems" ])
	var entry_state: State
	var states := [ ]
	var created_instances := { }
	var transitions_for_states := { } # (StateResource) -> [ TransitionItem ]
	
	for transition_item_resource in _transitions:
		for from_state_resource in transition_item_resource.from_states:
			transitions_for_states[from_state_resource] = transitions_for_states.get(from_state_resource, [ ])
			transitions_for_states[from_state_resource].append(transition_item_resource)
	
	for state_resource in transitions_for_states.keys():
		var transitions := [ ]
		var state: State = state_resource.get_state(state_machine, created_instances)
		states.append(state)
		if state_resource == entry_state_resource:
			entry_state = state
		
		for transition_item in transitions_for_states[state_resource]:
			var to_state: State = transition_item.to_state.get_state(state_machine, created_instances)
			var result_dic := _proccess_condition_usages(state_machine, transition_item.conditions, transition_item.operator, created_instances)
			var conditions: Array = result_dic[CONDITIONS]
			var result_groups: Array = result_dic[RESULT_GROUPS]
			transitions.append(StateTransition.new(to_state, conditions, result_groups))
		
		state.transitions = transitions
	
	return entry_state

func verify_table() -> Array: # [ Resource ]
	var problems := [ ]
	if not entry_state_resource:
		if not problems.has(self):
			problems.append(self)
		printerr("TransitionTableResource <%s> has no entry_state_resource!" % resource_path)
	
	if _transitions.empty():
		if not problems.has(self):
			problems.append(self)
		printerr("TransitionTableResource <%s> has no TransitionItems!" % resource_path)
	
	for transition in _transitions:
		if transition.from_states.empty():
			if not problems.has(transition):
				problems.append(transition)
			printerr("TransitionItem in <%s> has no from_states!" % resource_path)
		
		if not transition.to_state:
			if not problems.has(transition):
				problems.append(transition)
			printerr("TransitionItem in <%s> has no to_state!"  % resource_path)
		
		for neighbor_transition in _transitions:
			if transition.from_states.has(neighbor_transition.to_state):
				for condition_usage in transition.conditions:
					for neighbor_condition_usage in neighbor_transition.conditions:
						if condition_usage.condition == neighbor_condition_usage.condition and condition_usage.expected_result == neighbor_condition_usage.expected_result:
							if not problems.has(condition_usage):
								problems.append(condition_usage)
							if not problems.has(neighbor_condition_usage):
								problems.append(neighbor_condition_usage)
							printerr("The State <%s> is skipped and potentially a loop!"  % [ neighbor_transition.to_state.resource_path ])
			
			if neighbor_transition.from_states.has(transition.to_state):
				for condition_usage in transition.conditions:
					for neighbor_condition_usage in neighbor_transition.conditions:
						if condition_usage.condition == neighbor_condition_usage.condition and condition_usage.expected_result == neighbor_condition_usage.expected_result:
							if not problems.has(condition_usage):
								problems.append(condition_usage)
							if not problems.has(neighbor_condition_usage):
								problems.append(neighbor_condition_usage)
							printerr("The State <%s> is skipped and potentially a loop!"  % [ transition.to_state.resource_path ])
	
	return problems


func _proccess_condition_usages(
	state_machine,#: StateMachine,
	condition_usages: Array,
	operator: int,
	created_instances: Dictionary
) -> Dictionary:
	
	var conditions: Array = [ ]
	var count := condition_usages.size()
	for usage in condition_usages:
		conditions.append(usage.condition.get_condition(state_machine, usage.expected_result, created_instances))
	
	var result_groups: Array = [ ]
	for i in range(count):
		var idx := result_groups.size()
		result_groups.append(1)
		while i < count - 1 && operator == TransitionItemResource.Operator.AND:
			i += i
			result_groups[idx] += 1
	
	return { CONDITIONS: conditions, RESULT_GROUPS: result_groups }
