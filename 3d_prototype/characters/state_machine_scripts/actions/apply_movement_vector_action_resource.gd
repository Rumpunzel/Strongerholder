class_name ApplyMovementVectorActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ApplyMovementVectorAction.new()


class ApplyMovementVectorAction extends StateAction:
	var _character: Character
	var _navigation_agent: NavigationAgent
	var _actions: CharacterMovementActions
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine: Node) -> void:
		_character = state_machine.owner
		_navigation_agent = _character.get_navigation_agent()
		_actions = Utils.find_node_of_type_in_children(_character, CharacterMovementActions, true)
		# warning-ignore:unsafe_property_access
		_movement_stats = _character.movement_stats
		
		# warning-ignore:return_value_discarded
		_navigation_agent.connect("velocity_computed", self, "_on_velocity_computed")
	
	func on_update(_delta: float) -> void:
		var horizontal_movement: Vector2
		
		if _actions.moving_to_destination:
			if not _navigation_agent.is_navigation_finished():
				var destination := _navigation_agent.get_next_location()
				var direction := destination - _character.translation
				direction.y = _character.translation.y
				direction = direction.normalized()
				
				horizontal_movement = Vector2(direction.x, direction.z) * _movement_stats.move_speed
			else:
				horizontal_movement = Vector2.ZERO
		else:
			horizontal_movement = _actions.horizontal_movement_vector
		
		var new_movement_vector := Vector3(
			horizontal_movement.x,
			_actions.vertical_velocity,
			horizontal_movement.y
		)
		
		if _actions.moving_to_destination:
			_navigation_agent.set_velocity(new_movement_vector)
		else:
			_character.velocity = new_movement_vector
		
			if horizontal_movement != Vector2.ZERO:
				_character.look_position = new_movement_vector * 100.0 + _character.translation
	
	
	func _on_velocity_computed(safe_velocity: Vector3) -> void:
		if _actions.moving_to_destination:
			_character.velocity = safe_velocity
			
			if Vector2(safe_velocity.x, safe_velocity.z) != Vector2.ZERO:
				_character.look_position = safe_velocity * 100.0 + _character.translation
