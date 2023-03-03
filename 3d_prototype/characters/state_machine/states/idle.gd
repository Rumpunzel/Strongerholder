extends StateNode

export var _vertical_pull: float = 5.0

func on_update(_delta: float) -> void:
	_null_movement()
	_character.vertical_velocity = _vertical_pull

func _null_movement() -> void:
	_character.destination_input = _character.translation
	_character.horizontal_movement_vector = Vector2.ZERO
	_interaction_area.reset()
	
	var new_movement_vector := Vector3.DOWN * _character.vertical_velocity
	_character.velocity = new_movement_vector
