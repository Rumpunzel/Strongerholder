class_name Action2Resource
extends StateActionResource

func _create_action() -> StateAction:
	return Action2.new()


class Action2 extends StateAction:
	func awake(state_machine: Node) -> void:
		pass
	
	func on_state_enter():
		pass
	
	func on_update(delta: float) -> void:
		print("updated Action 2!")
