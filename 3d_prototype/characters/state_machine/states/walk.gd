extends StateNode

export var _vertical_pull: float = 5.0

var _avoid_obstacles: bool


func on_state_enter() -> void:
	_animation_tree.set("parameters/idle_walk/current", 1)

func on_update(_delta: float) -> void:
	horizontal_move_action()
	_character.vertical_velocity = _vertical_pull
	apply_movement_vector()
	var velocity := _character.velocity
	velocity.y = 0.0
	var normalised_speed := velocity.length() / _movement_stats.move_speed
	_animation_tree.set("parameters/walk_speed/blend_amount", normalised_speed)

func on_state_exit():
	_animation_tree.set("parameters/idle_walk/current", 0)
	_null_movement()


func horizontal_move_action() -> void:
	if _character.moving_to_destination:
		_navigation_agent.set_target_location(_character.destination_input)
	else:
		var move_speed := _character.target_speed * _movement_stats.move_speed
		
		_character.horizontal_movement_vector.x = _character.movement_input.x * move_speed
		_character.horizontal_movement_vector.y = _character.movement_input.z * move_speed

func apply_movement_vector() -> void:
	var horizontal_movement: Vector2
	
	if _character.moving_to_destination:
		if not _navigation_agent.is_navigation_finished():
			var destination := _navigation_agent.get_next_location()
			var direction := destination - _character.translation
			direction.y = _character.translation.y
			direction = direction.normalized()
			
			horizontal_movement = Vector2(direction.x, direction.z) * _movement_stats.move_speed
		else:
			horizontal_movement = Vector2.ZERO
	else:
		horizontal_movement = _character.horizontal_movement_vector
	
	var new_movement_vector := Vector3(
		horizontal_movement.x,
		-_character.vertical_velocity,
		horizontal_movement.y
	)
	
	if _avoid_obstacles and _character.moving_to_destination:
		_navigation_agent.set_velocity(new_movement_vector)
	else:
		_character.velocity = new_movement_vector
	
	if horizontal_movement != Vector2.ZERO:
		_character.look_position = new_movement_vector * 100.0 + _character.translation

func _null_movement() -> void:
	_character.destination_input = _character.translation
	_character.horizontal_movement_vector = Vector2.ZERO
	_interaction_area.reset()
	
	var new_movement_vector := Vector3.DOWN * _character.vertical_velocity
	_character.velocity = new_movement_vector
