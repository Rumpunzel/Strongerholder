extends StateNode

func on_update(_delta: float) -> void:
	_animation_tree.set("parameters/attack/active", true)
