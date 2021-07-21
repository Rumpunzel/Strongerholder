class_name AnimatorParameterActionResource
extends StateActionResource

enum ParameterType { Bool, Int, Float }

export(ParameterType) var _paramter_type
export var _parameter_name: String

export var _bool_value: bool
export var _int_value: int
export var _float_value: float

export(StateAction.SpecificMoment) var _when_to_run = StateAction.SpecificMoment.ON_STATE_ENTER


func _create_action() -> StateAction:
	return AnimatorParameterAction.new(
			_paramter_type,
			_parameter_name,
			_bool_value,
			_int_value,
			_float_value,
			_when_to_run
	)



class AnimatorParameterAction extends StateAction:
	enum { Bool, Int, Float }
	
	var _animation_tree: AnimationTree
	
	var _parameter_type: int
	var _parameter_name: String
	
	var _bool_value: bool
	var _int_value: int
	var _float_value: float

	var _when_to_run: int
	
	
	func _init(
			parameter_type: int,
			parameter_name: String,
			bool_value: bool,
			int_value: int,
			float_value: float,
			when_to_run: int
	):
		_parameter_type = parameter_type
		_parameter_name = "parameters/%s" % parameter_name
		
		_bool_value = bool_value
		_int_value = int_value
		_float_value = float_value
		
		_when_to_run = when_to_run
	
	
	func awake(state_machine: Node) -> void:
		_animation_tree = state_machine.owner.get_node("AnimationTree")
		assert(_animation_tree)
	
	
	func on_state_enter() -> void:
		if _when_to_run == StateAction.SpecificMoment.ON_STATE_ENTER:
			_set_parameter()
	
	func on_state_exit() -> void:
		if _when_to_run == StateAction.SpecificMoment.ON_STATE_EXIT:
			_set_parameter()
	
	
	func _set_parameter():
		var value
		match _parameter_type:
			Bool:
				value = _bool_value as bool
			Int:
				value = _int_value as int
			Float:
				value = _float_value as float
		
		_animation_tree.set(_parameter_name, value)
