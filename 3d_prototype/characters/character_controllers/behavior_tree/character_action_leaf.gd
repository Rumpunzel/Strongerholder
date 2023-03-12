class_name CharacterActionLeaf
extends ActionLeaf

static func _look_towards_nearest_interaction(blackboard: CharacterBlackboard) -> void:
	var current_interaction: CharacterController.Target = blackboard.current_interaction
	if current_interaction and weakref(current_interaction.node).get_ref():
		blackboard.character.look_position = current_interaction.position()


