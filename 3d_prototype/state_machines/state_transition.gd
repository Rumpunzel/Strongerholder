class_name StateTransition
extends StateComponent


var _target_state: State
var _conditions: Array
var _result_groups: Array

var _results := [ ]



func _init(
		target_state: State = null,
		conditions: Array = [ ],
		result_groups = null
) -> void:
	
	_target_state = target_state
	_conditions = conditions
	
	assert(_result_groups == null or _result_groups is Array)
	_result_groups = result_groups if (result_groups != null and not result_groups.empty()) else [1]
	assert(_result_groups is Array)
	
	_results.resize(_result_groups.size())
	for i in _results.size():
		_results[i] = false



func on_state_enter() -> void:
	for condition in _conditions:
		condition.condition.on_state_enter()

func on_state_exit() -> void:
	for condition in _conditions:
		condition.condition.on_state_exit()


func try_get_transition() -> State:
	return _target_state if _should_transition() else null



func _should_transition() -> bool:
	var count := _result_groups.size()
	var idx: int = 0
	
	for i in range(count):
		if idx >= _conditions.size():
			break
		
		for j in _result_groups[i]:
			var is_met: bool = _conditions[idx].is_met()
			
			_results[i] = is_met if j == 0 else (_results[i] and is_met)
			idx += 1
	
	
	for result in _results:
		if result:
			return true
	
	return false


func _to_string() -> String:
	return "State Transition:\n\tTarget State: %s, Conditions: %s, Result Groups: %s, Results; %s\n" % [ _target_state, _conditions, _result_groups, _results ]
