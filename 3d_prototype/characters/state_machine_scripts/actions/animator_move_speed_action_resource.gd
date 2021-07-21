class_name AnimatorMoveSpeedActionResource
extends StateActionResource

export var _parameter_name: String

func _create_action() -> StateAction:
	return AnimatorMoveSpeedAction.new(_parameter_name)


class AnimatorMoveSpeedAction extends StateAction:
	var _character: Character
	var _movement_stats: CharacterMovementStatsResource
	var _animation_tree: AnimationTree
	var _parameter_name: String
	
	
	func _init(parameter_name: String):
		_parameter_name = "parameters/%s" % parameter_name
	
	
	func awake(state_machine: Node) -> void:
		_character = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character.movement_stats
		_animation_tree = _character.get_node("AnimationTree")
	
	
	func on_update(_delta: float) -> void:
		var velocity := _character.velocity
		velocity.y = 0.0
		var normalised_speed := velocity.length() / _movement_stats.move_speed
		
		_animation_tree.set(_parameter_name, normalised_speed)
