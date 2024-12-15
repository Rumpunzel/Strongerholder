class_name JumpDescendingStateNode, "res://editor_tools/class_icons/nodes/icon_falling.svg"
extends StateNode

export(NodePath) var _animation_tree_node

var _gravity_magnitude: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _vertical_velocity := 0.0

onready var _movement_stats: CharacterMovementStatsResource = _character.movement_stats
onready var _animation_tree: AnimationTree = get_node(_animation_tree_node)

func on_state_enter() -> void:
	_vertical_velocity = _character.vertical_velocity
	_character.jump_input = false

func on_update(delta: float) -> void:
	_character.horizontal_move_action(true)
	_vertical_velocity -= _gravity_magnitude * _movement_stats.gravity_descend_multilpier * delta
	_character.vertical_velocity = _vertical_velocity

func on_state_exit():
	_animation_tree.set("parameters/grounded/current", 0)
