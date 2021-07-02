class_name TimeElapsedRandomConditionResource
extends StateConditionResource

export var _min_timer_length: float = 0.5
export var _max_timer_length: float = 1.0

func create_condition() -> StateCondition:
	return TimeElapsedRandomCondition.new(_min_timer_length, _max_timer_length)


class TimeElapsedRandomCondition extends StateCondition:
	var _timer_length: float
	var _start_time: float
	
	
	func _init(min_timer_length: float, max_timer_length: float):
		_timer_length = min_timer_length + randf() * max_timer_length
	
	
	func on_state_enter():
		_start_time = OS.get_unix_time()
	
	
	func _statement() -> bool:
		return OS.get_unix_time() >= _start_time + _timer_length
