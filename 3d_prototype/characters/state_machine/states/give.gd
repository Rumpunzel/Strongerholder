extends StateNode

onready var _animation_tree: AnimationTree = _character.get_node("AnimationTree")

func on_update(_delta: float) -> void:
	_animation_tree.set("parameters/give/active", true)
