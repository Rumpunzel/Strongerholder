class_name AnimatorMoveSpeedActionResource
extends StateActionResource

export var _parameter_name: String

func _create_action() -> StateAction:
	return AnimatorMoveSpeedAction.new(_parameter_name)


class AnimatorMoveSpeedAction extends StateAction:
	var _actions: CharacterMovementActions
	var _movement_stats: CharacterMovementStatsResource
	var _animation_tree: AnimationTree
	var _parameter_name: String
	
	
	func _init(parameter_name: String):
		_parameter_name = "parameters/%s" % parameter_name
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_actions = character.get_actions()
		# warning-ignore:unsafe_property_access
		_movement_stats = character.movement_stats
		_animation_tree = character.get_node("AnimationTree")
	
	
	func on_update(_delta: float) -> void:
		var normalised_speed := _actions.horizontal_movement_vector.length() / _movement_stats.move_speed
		_animation_tree.set(_parameter_name, normalised_speed)
