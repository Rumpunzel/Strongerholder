class_name TransitionTable
extends Resource
tool

enum { CONDITIONS, RESULT_GROUPS }

export(NodePath) var entry_state

export(Array, Resource) var _transitions
export var _graph_offsets := { }


func initialize(state_machine) -> StateNode:# StateMachine) -> StateNode:
	var problems := verify_table()
	assert(problems.empty(), "TransitionTableResource has %d %s!" % [ problems.size(), "problem" if problems.size() == 1 else "problems" ])
	var entry_state_node: StateNode
	var created_instances := { }
	var transitions_for_states := { } # (StateNodePath) -> [ TransitionItem ]
	
	for transition_item in _transitions:
		for from_state_node_path in transition_item.from_states:
			transitions_for_states[from_state_node_path] = transitions_for_states.get(from_state_node_path, [ ])
			transitions_for_states[from_state_node_path].append(transition_item)
	
	for state_node_path in transitions_for_states.keys():
		var transitions := [ ]
		var state_node: StateNode = state_machine.get_node(state_node_path)
		if state_node_path == entry_state:
			entry_state_node = state_node
		
		for transition_item in transitions_for_states[state_node_path]:
			var to_state: NodePath = transition_item.to_state
			var result_dic := _proccess_condition_usages(state_machine, transition_item.conditions, transition_item.operator, created_instances)
			var conditions: Array = result_dic[CONDITIONS]
			var result_groups: Array = result_dic[RESULT_GROUPS]
			transitions.append(StateNodeTransition.new(to_state, conditions, result_groups))
		
		state_node.transitions = transitions
	
	return entry_state_node

func verify_table() -> Array: # [ Resource ]
	var problems := [ ]
	if not entry_state:
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
