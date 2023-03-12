class_name ActionStateNode, "res://editor_tools/class_icons/nodes/icon_muscle_up.svg"
extends StateNode

export(NodePath) var _character_controller_node
export(NodePath) var _animation_tree_node

var _animation_parameter: String

onready var _character_controller: CharacterController = get_node(_character_controller_node)
onready var _animation_tree: AnimationTree = get_node(_animation_tree_node)


func on_state_enter() -> void:
	_animation_parameter = _character_controller.blackboard.current_interaction.to_animation_parameter()
	_animation_tree.set(_animation_parameter, true)

func on_update(_delta: float) -> void:
	_animation_parameter = _character_controller.blackboard.current_interaction.to_animation_parameter()
	print(_animation_parameter)
	_animation_tree.set(_animation_parameter, true)
