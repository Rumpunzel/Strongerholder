class_name CharacterController
extends BehaviorTree

signal attacked(started)
signal item_picked_up(item)
signal gave_item(item, amount)
signal took_item(item, amount)
signal operated()

export(NodePath) var _hurt_box_node
export(NodePath) var _inventory_node
export(NodePath) var _animation_tree_node

var _equipped_item: CharacterInventory.EquippedItem = null

onready var _hurt_box: HurtBox = get_node(_hurt_box_node)
onready var _inventory: CharacterInventory = get_node(_inventory_node)
onready var _animation_tree: AnimationTree = get_node(_animation_tree_node)


func _ready() -> void:
	_inventory.connect("item_equipped", self, "_on_item_equipped")
	_inventory.connect("item_unequipped", self, "_on_item_unequipped")
	_blackboard = CharacterBlackboard.new(self, owner, _animation_tree_node)


func get_potential_interaction(object: Node) -> Target:
	var interaction_resource: ItemResource = null
	
	if object is CollectableItem:
		return ItemInteraction.new(object, ObjectInteraction.InteractionType.PICK_UP, interaction_resource, 1)
	
	if object is Stash:
		return ItemInteraction.new(object, ItemInteraction.InteractionType.TRADE, interaction_resource, 1)
	
	if object is Workstation and (object as Workstation).can_be_operated():
		return ItemInteraction.new(object, ObjectInteraction.InteractionType.OPERATE, interaction_resource, 1)
	
	if _hurt_box.can_attack_object(object, _equipped_item):
		return ObjectInteraction.new(object, ObjectInteraction.InteractionType.ATTACK)
	
	return null


func attack(started: bool) -> void:
	if started:
		_hurt_box.damage_hit_boxes(_equipped_item)
	emit_signal("attacked", started)

func pick_up(item_node: CollectableItem) -> void:
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	var item: ItemResource = item_node.item_resource
	emit_signal("item_picked_up", item)
	# TODO: properly destroy item instead of only freeing
	item_node.queue_free()

func give(stash: Stash, item: ItemResource, amount: int) -> void:
	# warning-ignore:return_value_discarded
	stash.stash(item, amount)
	emit_signal("gave_item", item, amount)

func operate(workstation: Workstation) -> void:
	workstation.operate()
	emit_signal("operated")

func take(stash: Stash, item: ItemResource, amount: int) -> void:
	# warning-ignore:return_value_discarded
	stash.take(item, amount)
	emit_signal("took_item", item, amount)



func _on_item_equipped(equipment: CharacterInventory.EquippedItem):
	_equipped_item = equipment

func _on_item_unequipped(equipment: CharacterInventory.EquippedItem):
	if _equipped_item == equipment:
		_equipped_item = null





#func smart_interact_with_nearest_object_of_type(object_type: ObjectResource, custom_array_to_search: Array, overwrite_dibs: bool) -> void:
#	if _occupied():
#		return
#
#	var interaction_objects := [ ]
#	filter_array_for_type(interaction_area.objects_in_area, object_type)
#
#	var perception_objects := [ ]
#	filter_array_for_type(perception_area.objects_in_area, object_type) if custom_array_to_search.empty() else custom_array_to_search
#
#	var point_to_walk_to := _smart_interact_with_nearest(interaction_objects, perception_objects, null, overwrite_dibs)
#	_character.destination_input = point_to_walk_to


#func interact_with_nearest_object_of_type(object_type: ObjectResource, custom_array_to_search: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool) -> void:
#	if _occupied():
#		return
#
#	var interaction_objects := [ ]
#	filter_array_for_type(interaction_area.objects_in_area, object_type)
#
#	var perception_objects := [ ]
#	filter_array_for_type(perception_area.objects_in_area, object_type) if custom_array_to_search.empty() else custom_array_to_search
#
#	var point_to_walk_to := _interact_with_nearest(interaction_objects, perception_objects, interaction_type, item, how_many, all, overwrite_dibs)
#	_character.destination_input = point_to_walk_to


#func smart_interact_with_specific_object(object: Node, interaction_objects: Array, inventory: CharacterInventory, overwrite_dibs: bool) -> void:
#	if _occupied():
#		return
#
#	var point_to_walk_to := _smart_interact_with_nearest(interaction_objects, [ object ], inventory, overwrite_dibs)
#	_character.destination_input = point_to_walk_to


#func interact_with_specific_object(object: Node, interaction_objects: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool) -> void:
#	if _occupied():
#		return
#
#	var point_to_walk_to := _interact_with_nearest(interaction_objects, [ object ], interaction_type, item, how_many, all, overwrite_dibs)
#	_character.destination_input = point_to_walk_to


#func find_nearest_smart_interaction(objects: Array, inventory: CharacterInventory, overwrite_dibs: bool) -> Target:
#	var nearest: Target = null
#	var closest_distance: float = INF
#
#	for object in objects:
#		# warning-ignore:unsafe_property_access
#		if not object or object == owner or object.owner == owner or (not overwrite_dibs and object.has_method("is_dibbable") and not object.is_dibbable(self)):
#			continue
#
#		var potential_interaction := _determine_potential_interaction(object, inventory)
#		if not potential_interaction:
#			continue
#
#		var distance := _character.translation.distance_squared_to(object.global_transform.origin)
#		if distance < closest_distance:
#			closest_distance = distance
#			nearest = potential_interaction
#
#	return nearest


static func filter_array_for_type(array: Array, object_type: ObjectResource) -> Array:
	var filtered_array := [ ]
	for object in array:
		if object is CollectableItem:
			if object.item_resource == object_type:
				filtered_array.append(object)
		elif object is HitBox or object is Stash:
			if object.owner.structure_resource == object_type:
				filtered_array.append(object)
	
	return filtered_array


#func _smart_interact_with_nearest(interactable_objects: Array, perceived_objects: Array, inventory: CharacterInventory, overwrite_dibs: bool) -> Vector3:
#	# Default is no movement at all
#	var point_to_walk_to := _character.translation
#	var nearest_interaction: Target = blackboard.nearest_interaction
#
#	# If there is a current target
#	if nearest_interaction and nearest_interaction.type:
#		# Check if we are in range
#		if interactable_objects.has(nearest_interaction.node):
#			_set_current_interaction(nearest_interaction)
#		elif perceived_objects.has(nearest_interaction.node):
#			point_to_walk_to = nearest_interaction.position()
#		else:
#			reset()
#	else:
#		# Check if there is an object in the immediate vicinity to interact with
#		var nearest_smart_interaction := find_nearest_smart_interaction(interactable_objects, inventory, overwrite_dibs)
#		_set_nearest_interaction(nearest_smart_interaction)
#		if nearest_interaction:
#			_set_current_interaction(nearest_interaction)
#		else:
#			# Check in the broader vicinity
#			nearest_smart_interaction = find_nearest_smart_interaction(perceived_objects, inventory, overwrite_dibs)
#			_set_nearest_interaction(nearest_smart_interaction)
#			if nearest_interaction:
#				point_to_walk_to = nearest_interaction.position()
#
#	return point_to_walk_to


#func _interact_with_nearest(interactable_objects: Array, perceived_objects: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool) -> Vector3:
#	# Default is no movement at all
#	var point_to_walk_to := _character.translation
#	var _nearest_interaction: Target = blackboard.nearest_interaction
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


#func _find_nearest_interaction(objects: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool) -> ItemInteraction:
#	assert(interaction_type)
#
#	var nearest: ItemInteraction = null
#	var closest_distance: float = INF
#	var amount := how_many
#
#	for object in objects:
#		# warning-ignore:unsafe_property_access
#		if not object or object == owner or object.owner == owner or (not overwrite_dibs and object.has_method("is_dibbable") and not object.is_dibbable(self)):
#			continue
#
#		var valid := true
#		match interaction_type:
#			ItemInteraction.InteractionType.GIVE:
#				# warning-ignore:unsafe_cast
#				if object is Stash and (object as Stash).full(item):
#					valid = false
#
#			ItemInteraction.ItemInteractionType.TAKE:
#				# warning-ignore:unsafe_cast
#				if object is Stash:
#					if not (object as Stash).contains(item):
#						valid = false
#					elif all:
#						# warning-ignore:unsafe_cast
#						amount = int(min(how_many, (object as Stash).count(item)))
#
#		if not valid:
#			continue
#
#		var distance := _character.translation.distance_squared_to(object.global_transform.origin)
#		if distance < closest_distance:
#			closest_distance = distance
#			nearest = ItemInteraction.new(object, interaction_type, item, amount)
#
#	return nearest


#func _determine_potential_interaction(object: Node, inventory: CharacterInventory) -> Target:
#	var potential_interaction: Target = null
#	if _interaction_area:
#		potential_interaction = _interaction_area.get_potential_interaction(object, inventory)
#	else:
#		print("InteractionArea is not defined!")
#	if potential_interaction:
#		return potential_interaction
#
#	if _hurt_box:
#		potential_interaction = _hurt_box.can_attack_object()
#	else:
#		print("HurtBox is not defined!")
#	return potential_interaction


func _occupied() -> bool:
	return _blackboard.current_interaction and _blackboard.current_interaction.type


#func _set_current_job(new_job) -> void:
#	current_job = new_job
#	# warning-ignore:return_value_discarded
#	_inventory.add(current_job.tool_resource)




class Target:
	const ANIMATION_PARAMETER := "parameters/%s/active"
	
	var node: Spatial
	
	func _init(new_node: Spatial) -> void:
		node = new_node
	
	func position() -> Vector3:
		return node.global_transform.origin
	
	func to_animation_parameter() -> String:
		return ""

class ItemInteraction extends Target:
	enum InteractionType {
		GIVE,
		TAKE,
		TRADE,
	}

	var interaction_type: int
	var item_resource: ItemResource
	var item_amount: int
	
	func _init(new_node: Spatial, new_interaction_type: int, new_resource: ItemResource, new_item_amount: int).(new_node) -> void:
		interaction_type = new_interaction_type
		item_resource = new_resource
		item_amount = new_item_amount
	
	func to_animation_parameter() -> String:
		match interaction_type:
			InteractionType.GIVE:
				return ANIMATION_PARAMETER % "give"
			InteractionType.TAKE:
				return ANIMATION_PARAMETER % "take"
			_:
				assert(false, "This animation is not supported for ItemInteractions!")
		
		return ""

class ObjectInteraction extends Target:
	enum InteractionType {
		ATTACK,
		OPERATE,
		PICK_UP,
	}
	
	var interaction_type: int
	
	func _init(new_node: Spatial, new_interaction_type: int).(new_node) -> void:
		interaction_type = new_interaction_type
	
	func to_animation_parameter() -> String:
		match interaction_type:
			InteractionType.ATTACK:
				return "attack"
			InteractionType.OPERATE:
				return "operate"
			InteractionType.PICK_UP:
				return "pick_up"
			_:
				assert(false, "This animation is not supported for ObjectInteractions!")
		
		return ""
