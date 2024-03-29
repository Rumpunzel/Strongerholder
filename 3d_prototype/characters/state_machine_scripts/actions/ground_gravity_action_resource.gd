class_name GroundGravityActionResource
extends StateActionResource

export var _vertical_pull: float = 5.0

func _create_action() -> StateAction:
	return GroundGravityAction.new(_vertical_pull)


class GroundGravityAction extends StateAction:
	var _actions: CharacterMovementActions
	var _vertical_pull: float
	
	
	func _init(vertical_pull):
		_vertical_pull = -vertical_pull
	
	
	func awake(state_machine: Node) -> void:
		_actions = Utils.find_node_of_type_in_children(state_machine.owner, CharacterMovementActions, true)
	
	func on_update(_delta: float) -> void:
		_actions.vertical_velocity = _vertical_pull
