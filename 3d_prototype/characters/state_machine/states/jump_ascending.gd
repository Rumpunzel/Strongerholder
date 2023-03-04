class_name JumpAscendingStateNode, "res://editor_tools/class_icons/nodes/icon_jump_across.svg"
extends StateNode

var _gravity_magnitude: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _vertical_velocity := 0.0

onready var _movement_stats: CharacterMovementStatsResource = _character.movement_stats
onready var _animation_tree: AnimationTree = _character.get_node("AnimationTree")

func on_state_enter() -> void:
	_animation_tree.set("parameters/grounded/current", 1)
	_vertical_velocity = sqrt(_movement_stats.jump_height * 3.0 * _gravity_magnitude * _movement_stats.gravity_ascend_multiplier)

func on_update(delta: float) -> void:
	_character.horizontal_move_action(true)
	_vertical_velocity -= _gravity_magnitude * _movement_stats.gravity_ascend_multiplier * delta
	_character.vertical_velocity = _vertical_velocity
