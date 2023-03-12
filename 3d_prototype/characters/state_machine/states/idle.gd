class_name IdleStateNode, "res://editor_tools/class_icons/nodes/icon_person.svg"
extends StateNode

export var _vertical_pull: float = 5.0

onready var _character_controller: CharacterController = Utils.find_node_of_type_in_children(_character, CharacterController)

func on_update(_delta: float) -> void:
	_character.null_movement()
	_character.vertical_velocity = _vertical_pull
	_character_controller.reset()
