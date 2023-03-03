extends StateNode

export var _vertical_pull: float = 5.0

onready var _movement_stats: CharacterMovementStatsResource = _character.movement_stats
onready var _interaction_area: InteractionArea = Utils.find_node_of_type_in_children(_character, InteractionArea)
onready var _animation_tree: AnimationTree = _character.get_node("AnimationTree")


func on_state_enter() -> void:
	_animation_tree.set("parameters/idle_walk/current", 1)

func on_update(_delta: float) -> void:
	_character.horizontal_move_action()
	_character.vertical_velocity = _vertical_pull
	var velocity := _character.apply_movement_vector()
	velocity.y = 0.0
	var normalised_speed := velocity.length() / _movement_stats.move_speed
	_animation_tree.set("parameters/walk_speed/blend_amount", normalised_speed)

func on_state_exit():
	_character.null_movement()
	_interaction_area.reset()
	_animation_tree.set("parameters/idle_walk/current", 0)
