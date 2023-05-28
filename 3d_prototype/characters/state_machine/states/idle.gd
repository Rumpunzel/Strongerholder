class_name IdleStateNode, "res://editor_tools/class_icons/nodes/icon_person.svg"
extends StateNode

export var _vertical_pull: float = 5.0

func on_update(_delta: float) -> void:
	_character.null_movement()
	_character.vertical_velocity = _vertical_pull
