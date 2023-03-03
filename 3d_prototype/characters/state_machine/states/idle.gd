extends StateNode

export var _vertical_pull: float = 5.0

onready var _interaction_area: InteractionArea = Utils.find_node_of_type_in_children(_character, InteractionArea)

func on_update(_delta: float) -> void:
	_character.null_movement()
	_character.vertical_velocity = _vertical_pull
	_interaction_area.reset()
