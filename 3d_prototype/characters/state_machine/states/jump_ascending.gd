extends StateNode

var _gravity_magnitude: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _vertical_velocity := 0.0
var _avoid_obstacles: bool


func _ready() -> void:
	if _navigation_agent.avoidance_enabled and _movement_stats.avoid_obstacles:
		_avoid_obstacles = true
		# warning-ignore:return_value_discarded
		_navigation_agent.connect("velocity_computed", _character, "set_velocity")
	else:
		_avoid_obstacles = false


func on_state_enter() -> void:
	_animation_tree.set("parameters/grounded/current", 1)
	_vertical_velocity = sqrt(_movement_stats.jump_height * 3.0 * _gravity_magnitude * _movement_stats.gravity_ascend_multiplier)

func on_update(delta: float) -> void:
	horizontal_move_action()
	_vertical_velocity -= _gravity_magnitude * _movement_stats.gravity_ascend_multiplier * delta
	_character.vertical_velocity = _vertical_velocity


func horizontal_move_action() -> void:
	if _character.moving_to_destination:
		_navigation_agent.set_target_location(_character.destination_input)
	else:
		var move_speed := _character.target_speed * _movement_stats.move_speed * _movement_stats.aerial_modifier
		
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
		_character.vertical_velocity,
		horizontal_movement.y
	)
	
	if _avoid_obstacles and _character.moving_to_destination:
		_navigation_agent.set_velocity(new_movement_vector)
	else:
		_character.velocity = new_movement_vector
	
	if horizontal_movement != Vector2.ZERO:
		_character.look_position = new_movement_vector * 100.0 + _character.translation
