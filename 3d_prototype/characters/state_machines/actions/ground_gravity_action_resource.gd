class_name GroundGravityActionResource
extends StateActionResource

export var _vertical_pull: float = 5.0

func _create_action() -> StateAction:
	return GroundGravityAction.new(_vertical_pull)


class GroundGravityAction extends StateAction:
	var _character: Character
	
	var _vertical_pull: float
	
	
	func _init(vertical_pull):
		_vertical_pull = -vertical_pull
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	func on_update(_delta: float) -> void:
		_character.vertical_velocity = _vertical_pull
