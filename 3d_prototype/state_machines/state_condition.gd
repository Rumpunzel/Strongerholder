class_name StateCondition
extends StateComponent


var origin_resource: Resource


var _is_cached := false
var _cached_statement := false



func awake(_state_machine) -> void:# StateMachine) -> void:
	pass

func on_state_enter() -> void:
	pass

func on_state_exit() -> void:
	pass


func get_statement() -> bool:
	if not _is_cached:
		_is_cached = true
		_cached_statement = _statement()
	
	return _cached_statement


func clear_statement_cache() -> void:
	_is_cached = false



func _statement() -> bool:
	assert(false)
	return false


func _to_string() -> String:
	return "%s" % origin_resource



class Condition:
	var condition: StateCondition
	
	var _state_machine#: StateMachine
	var _expected_result: bool
	
	
	func _init(
			state_machine,#: StateMachine,
			new_condition: StateCondition,
			expected_result: bool
	) -> void:
		
		condition = new_condition
		
		_state_machine = state_machine
		_expected_result = expected_result
	
	
	func is_met() -> bool:
		return condition.get_statement() == _expected_result
	
	
	func _to_string() -> String:
		return "(%s: %s)" % [ condition, _expected_result ]
