class_name OccupationActionLeaf
extends ActionLeaf

static func _nearest_percieved_target(blackboard: OccupationBlackboard, overwrite_dibs: bool = false) -> CharacterController.Target:
	return _nearest_target_of(
		blackboard,
		blackboard.perception_area.objects_in_area,
		overwrite_dibs
	)


static func _nearest_target_of(
	blackboard: OccupationBlackboard,
	objects: Array,
	overwrite_dibs: bool
) -> CharacterController.Target:
	var character := blackboard.character
	
	var nearest: CharacterController.Target = null
	var closest_distance: float = INF
	
	for object in objects:
		# warning-ignore:unsafe_property_access
		if not object or object == character or object.owner == character or (not overwrite_dibs and object.has_method("is_dibbable") and not object.is_dibbable(character)):
			continue
		
		var potential_interaction := _determine_potential_interaction(blackboard, object)
		if not potential_interaction:
			continue
		
		var distance := character.translation.distance_squared_to(object.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			nearest = potential_interaction
	
	return nearest

static func _determine_potential_interaction(blackboard: CharacterBlackboard, object: Node) -> CharacterController.Target:
	var potential_interaction: CharacterController.Target = null
	
	potential_interaction = blackboard.interaction_area.get_potential_interaction(object, blackboard.inventory)
	if potential_interaction:
		return potential_interaction
	
	potential_interaction = blackboard.hurt_box.can_attack_object(object)
	return potential_interaction
