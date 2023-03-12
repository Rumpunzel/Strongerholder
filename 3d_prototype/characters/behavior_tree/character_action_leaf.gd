class_name CharacterActionLeaf
extends ActionLeaf

static func _look_towards_nearest_interaction(blackboard: CharacterController.CharacterBlackboard) -> void:
	var current_interaction := blackboard.current_interaction
	if current_interaction and weakref(current_interaction.node).get_ref():
		blackboard.character.look_position = current_interaction.position()

static func _nearest_interactable_target(blackboard: CharacterController.CharacterBlackboard, overwrite_dibs: bool) -> CharacterController.Target:
	return _nearest_target_of(
		blackboard,
		blackboard.interaction_area.objects_in_area,
		overwrite_dibs
	)

static func _nearest_percieved_target(blackboard: CharacterController.CharacterBlackboard, overwrite_dibs: bool) -> CharacterController.Target:
	return _nearest_target_of(
		blackboard,
		blackboard.perception_area.objects_in_area,
		overwrite_dibs
	)


static func _nearest_target_of(
	blackboard: CharacterController.CharacterBlackboard,
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

static func _determine_potential_interaction(blackboard: CharacterController.CharacterBlackboard, object: Node) -> CharacterController.Target:
	var potential_interaction: CharacterController.Target = null
	
	potential_interaction = blackboard.interaction_area.get_potential_interaction(object, blackboard.inventory)
	if potential_interaction:
		return potential_interaction
	
	potential_interaction = blackboard.hurt_box.can_attack_object()
	return potential_interaction



#
#
#func interact_with_specific_object(object: Node, interaction_objects: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool, blackboard: CharacterController.CharacterBlackboard) -> void:
#	if _occupied(blackboard):
#		return
#
#	var point_to_walk_to := _interact_with_nearest(interaction_objects, [ object ], interaction_type, item, how_many, all, overwrite_dibs, blackboard)
#	blackboard.character.destination_input = point_to_walk_to
#
#func _interact_with_nearest(interactable_objects: Array, perceived_objects: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool, blackboard: CharacterController.CharacterBlackboard) -> Vector3:
#	# Default is no movement at all
#	var point_to_walk_to := blackboard.character.translation
#	var _nearest_interaction: CharacterController.Interaction = blackboard.nearest_interaction
#
#	# If there is a current target
#	if _nearest_interaction and _nearest_interaction.type:
#		# Check if we are in range
#		if interactable_objects.has(_nearest_interaction.node):
#			_set_current_interaction(_nearest_interaction)
#		elif perceived_objects.has(_nearest_interaction.node):
#			point_to_walk_to = _nearest_interaction.position()
#		else:
#			reset()
#	else:
#		# Check if there is an object in the immediate vicinity to interact with
#		var nearest_interaction := _find_nearest_interaction(interactable_objects, interaction_type, item, how_many, all, overwrite_dibs)
#		_set_nearest_interaction(nearest_interaction)
#		if _nearest_interaction:
#			_set_current_interaction(_nearest_interaction)
#		else:
#			# Check in the broader vicinity
#			nearest_interaction = _find_nearest_interaction(perceived_objects, interaction_type, item, how_many, all, overwrite_dibs)
#			_set_nearest_interaction(nearest_interaction)
#			if _nearest_interaction:
#				point_to_walk_to = _nearest_interaction.position()
#
#	return point_to_walk_to
#
#
#func _occupied(blackboard: CharacterController.CharacterBlackboard) -> bool:
#	return blackboard.current_interaction
