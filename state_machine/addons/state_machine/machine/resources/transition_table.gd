class_name TransitionTableResource, "res://addons/state_machine/icons/icon_notebook.svg"
extends Resource

enum { CONDITIONS, RESULT_GROUPS }

# warning-ignore:unused_class_variable
export var use_physics_process := false

export(Array, Resource) var _transitions


func get_initial_state(state_machine) -> State:# StateMachine) -> State:
	var states := _initialize_states(state_machine)
	
	assert(not states.empty(), "State Machine has not states.")
	return states.front()


func _initialize_states(state_machine) -> Array:
	var states := [ ]
	var created_instances := { }
	
	var from_states := { }
	
	for transition in _transitions:
		var from_state: StateResource = transition.from_state
		
		from_states[from_state] = from_states.get(from_state, [ ])
		from_states[from_state].append(transition)
	
	
	for from_state in from_states.keys():
		var transitions := [ ]
		var state: State = from_state.get_state(state_machine, created_instances)
		states.append(state)
		
		for transition_item in from_states[from_state]:
			var to_state: State = transition_item.to_state.get_state(state_machine, created_instances)
			var result_dic := _proccess_condition_usages(state_machine, transition_item.conditions, transition_item.operator, created_instances)
			var conditions: Array = result_dic[CONDITIONS]
			var result_groups: Array = result_dic[RESULT_GROUPS]
			
			transitions.append(StateTransition.new(to_state, conditions, result_groups))
		
		state.transitions = transitions
	
	return states


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
		
		while i < count - 1 && operator == ConditionUsageResource.Operator.AND:
			i += i
			result_groups[idx] += 1
	
	return { CONDITIONS: conditions, RESULT_GROUPS: result_groups }
