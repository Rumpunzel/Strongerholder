class_name AnimationConditionResource
extends StateConditionResource

export var _expected_bool_value: bool

func create_condition() -> StateCondition:
	return AnimationCondition.new(_expected_bool_value)

class AnimationCondition extends StateCondition:
	var _character_controller: CharacterController
	var _animation_tree: AnimationTree
	var _bool_value: bool
	
	func _init(bool_value: bool):
		_bool_value = bool_value
	
	func awake(state_machine: Node) -> void:
		_character_controller = state_machine.owner.get_node("CharacterController")
		_animation_tree = state_machine.owner.get_node("AnimationTree")
		assert(_character_controller)
		assert(_animation_tree)
	
	func _statement() -> bool:
		var animation_parameter := ActionStateNode.translate_interaction_to_parameter(_character_controller.blackboard.current_interaction)
		return _animation_tree.get("parameters/%s/active" % animation_parameter) == _bool_value
