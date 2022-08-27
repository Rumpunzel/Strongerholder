class_name Action1Resource
extends StateActionResource

func _create_action() -> StateAction:
	return Action1.new()


class Action1 extends StateAction:
	func awake(state_machine: Node) -> void:
		pass
	
	func on_state_enter():
		print("entered Action 1!")
	
	func on_update(delta: float) -> void:
		pass
