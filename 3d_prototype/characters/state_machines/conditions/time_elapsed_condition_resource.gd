class_name TimeElapsedConditionResource
extends StateConditionResource

export var _timer_length: float = 0.5

func create_condition() -> StateCondition:
	return TimeElapsedCondition.new(_timer_length)


class TimeElapsedCondition extends StateCondition:
	var _timer_length: float
	var _start_time: float
	
	
	func _init(timer_length: float):
		_timer_length = timer_length * 1000.0
	
	
	func on_state_enter():
		_start_time = float(OS.get_ticks_msec())
	
	
	func _statement() -> bool:
		return OS.get_ticks_msec() >= _start_time + _timer_length
