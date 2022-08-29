class_name StateAction
extends StateComponent

enum SpecificMoment { ON_STATE_ENTER, ON_STATE_EXIT, ON_UPDATE }

# warning-ignore:unused_class_variable
var origin_resource: Resource


func awake(_state_machine: Node) -> void:
	pass

func on_state_enter() -> void:
	pass

func on_update(_delta: float) -> void:
	pass

func on_input(_input: InputEvent) -> void:
	pass

func on_state_exit() -> void:
	pass
