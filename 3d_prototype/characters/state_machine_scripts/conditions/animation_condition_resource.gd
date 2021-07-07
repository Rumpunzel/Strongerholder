class_name AnimationConditionResource
extends StateConditionResource

enum ParameterType { Bool, Int, Float }

export(ParameterType) var _paramter_type
export var _parameter_name: String

export var _expected_bool_value: bool
export var _expected_int_value: int
export var _expected_float_value: float


func _create_action() -> StateCondition:
	return AnimationCondition.new(
			_paramter_type,
			_parameter_name,
			_expected_bool_value,
			_expected_int_value,
			_expected_float_value
	)

class AnimationCondition extends StateCondition:
	enum { Bool, Int, Float }
	
	var _animation_tree: AnimationTree
	
	var _parameter_type: int
	var _parameter_name: String
	
	var _bool_value: bool
	var _int_value: int
	var _float_value: float
	
	
	func _init(
			parameter_type: int,
			parameter_name: String,
			bool_value: bool,
			int_value: int,
			float_value: float
	):
		_parameter_type = parameter_type
		_parameter_name = "parameters/%s" % parameter_name
		
		_bool_value = bool_value
		_int_value = int_value
		_float_value = float_value
	
	
	func awake(state_machine) -> void:
		_animation_tree = state_machine.owner.get_node("AnimationTree")
		assert(_animation_tree)
	
	
	func _statement() -> bool:
		var value
		match _parameter_type:
			Bool:
				value = _bool_value as bool
			Int:
				value = _int_value as int
			Float:
				value = _float_value as float
		
		return _animation_tree.get(_parameter_name) == value
