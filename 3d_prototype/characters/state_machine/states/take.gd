extends StateNode

func on_state_enter() -> void:
	_animation_tree.set("parameters/take/active", true)
