class_name CharacterController
extends BehaviorTreeRoot

enum ItemInteractionType {
	GIVE,
	TAKE,
}

enum ObjectInteractionType {
	ATTACK,
	OPERATE,
	PICK_UP,
}

export(NodePath) var _inventory_node
export(NodePath) var _perception_area_node
export(NodePath) var _interaction_area_node
export(NodePath) var _hurt_box_node

onready var _character: Character = owner
onready var _inventory: CharacterInventory = get_node(_inventory_node)
onready var perception_area: Area = get_node(_perception_area_node)
onready var interaction_area: Area = get_node(_perception_area_node)
onready var _hurt_box: Area = get_node(_hurt_box_node)
# warning-ignore:unsafe_method_access
onready var _spotted_items: SpottedItems = _character.get_navigation().spotted_items

var current_job: Workstation.Job = null setget _set_current_job


func smart_interact_with_nearest_object_of_type(object_type: ObjectResource, custom_array_to_search: Array, overwrite_dibs: bool) -> void:
	if _occupied():
		return
	
	var interaction_objects := [ ]
	if interaction_area:
		filter_array_for_type(interaction_area.areas_in_area, object_type)
	else:
		print("InteractionArea is not defined!")
	
	var perception_objects := [ ]
	if perception_area:
		filter_array_for_type(perception_area.objects_in_area, object_type) if custom_array_to_search.empty() else custom_array_to_search
	else:
		print("PerceptionArea is not defined!")
	
	var point_to_walk_to := _smart_interact_with_nearest(interaction_objects, perception_objects, null, overwrite_dibs)
	_character.destination_input = point_to_walk_to


func interact_with_nearest_object_of_type(object_type: ObjectResource, custom_array_to_search: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool) -> void:
	if _occupied():
		return
	
	var interaction_objects := [ ]
	if interaction_area:
		filter_array_for_type(interaction_area.areas_in_area, object_type)
	else:
		print("InteractionArea is not defined!")
	
	var perception_objects := [ ]
	if perception_area:
		filter_array_for_type(perception_area.objects_in_area, object_type) if custom_array_to_search.empty() else custom_array_to_search
	else:
		print("PerceptionArea is not defined!")
	
	var point_to_walk_to := _interact_with_nearest(interaction_objects, perception_objects, interaction_type, item, how_many, all, overwrite_dibs)
	_character.destination_input = point_to_walk_to


func smart_interact_with_specific_object(object: Node, interaction_objects: Array, inventory: CharacterInventory, overwrite_dibs: bool) -> void:
	if _occupied():
		return
	
	var point_to_walk_to := _smart_interact_with_nearest(interaction_objects, [ object ], inventory, overwrite_dibs)
	_character.destination_input = point_to_walk_to


func interact_with_specific_object(object: Node, interaction_objects: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool) -> void:
	if _occupied():
		return
	
	var point_to_walk_to := _interact_with_nearest(interaction_objects, [ object ], interaction_type, item, how_many, all, overwrite_dibs)
	_character.destination_input = point_to_walk_to


func find_nearest_smart_interaction(objects: Array, inventory: CharacterInventory, overwrite_dibs: bool) -> Target:
	var nearest: Target = null
	var closest_distance: float = INF
	
	for object in objects:
		# warning-ignore:unsafe_property_access
		if not object or object == owner or object.owner == owner or (not overwrite_dibs and object.has_method("is_dibbable") and not object.is_dibbable(self)):
			continue
		
		var potential_interaction := _determine_potential_interaction(object, inventory)
		if not potential_interaction:
			continue
		
		var distance := _character.translation.distance_squared_to(object.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			nearest = potential_interaction
	
	return nearest


func reset() -> void:
	_set_current_interaction(null)
	_set_nearest_interaction(null)


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


func _smart_interact_with_nearest(interactable_objects: Array, perceived_objects: Array, inventory: CharacterInventory, overwrite_dibs: bool) -> Vector3:
	# Default is no movement at all
	var point_to_walk_to := _character.translation
	var nearest_interaction: Target = blackboard.nearest_interaction
	
	# If there is a current target
	if nearest_interaction and nearest_interaction.type:
		# Check if we are in range
		if interactable_objects.has(nearest_interaction.node):
			_set_current_interaction(nearest_interaction)
		elif perceived_objects.has(nearest_interaction.node):
			point_to_walk_to = nearest_interaction.position()
		else:
			reset()
	else:
		# Check if there is an object in the immediate vicinity to interact with
		var nearest_smart_interaction := find_nearest_smart_interaction(interactable_objects, inventory, overwrite_dibs)
		_set_nearest_interaction(nearest_smart_interaction)
		if nearest_interaction:
			_set_current_interaction(nearest_interaction)
		else:
			# Check in the broader vicinity
			nearest_smart_interaction = find_nearest_smart_interaction(perceived_objects, inventory, overwrite_dibs)
			_set_nearest_interaction(nearest_smart_interaction)
			if nearest_interaction:
				point_to_walk_to = nearest_interaction.position()
	
	return point_to_walk_to


func _interact_with_nearest(interactable_objects: Array, perceived_objects: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool) -> Vector3:
	# Default is no movement at all
	var point_to_walk_to := _character.translation
	var _nearest_interaction: Target = blackboard.nearest_interaction
	
	# If there is a current target
	if _nearest_interaction and _nearest_interaction.type:
		# Check if we are in range
		if interactable_objects.has(_nearest_interaction.node):
			_set_current_interaction(_nearest_interaction)
		elif perceived_objects.has(_nearest_interaction.node):
			point_to_walk_to = _nearest_interaction.position()
		else:
			reset()
	else:
		# Check if there is an object in the immediate vicinity to interact with
		var nearest_interaction := _find_nearest_interaction(interactable_objects, interaction_type, item, how_many, all, overwrite_dibs)
		_set_nearest_interaction(nearest_interaction)
		if _nearest_interaction:
			_set_current_interaction(_nearest_interaction)
		else:
			# Check in the broader vicinity
			nearest_interaction = _find_nearest_interaction(perceived_objects, interaction_type, item, how_many, all, overwrite_dibs)
			_set_nearest_interaction(nearest_interaction)
			if _nearest_interaction:
				point_to_walk_to = _nearest_interaction.position()
	
	return point_to_walk_to


func _find_nearest_interaction(objects: Array, interaction_type: int, item: ItemResource, how_many: int, all: bool, overwrite_dibs: bool) -> ItemInteraction:
	assert(interaction_type)
	
	var nearest: ItemInteraction = null
	var closest_distance: float = INF
	var amount := how_many
	
	for object in objects:
		# warning-ignore:unsafe_property_access
		if not object or object == owner or object.owner == owner or (not overwrite_dibs and object.has_method("is_dibbable") and not object.is_dibbable(self)):
			continue
		
		var valid := true
		match interaction_type:
			ItemInteractionType.GIVE:
				# warning-ignore:unsafe_cast
				if object is Stash and (object as Stash).full(item):
					valid = false
			
			ItemInteractionType.TAKE:
				# warning-ignore:unsafe_cast
				if object is Stash:
					if not (object as Stash).contains(item):
						valid = false
					elif all:
						# warning-ignore:unsafe_cast
						amount = int(min(how_many, (object as Stash).count(item)))
		
		if not valid:
			continue
		
		var distance := _character.translation.distance_squared_to(object.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			nearest = ItemInteraction.new(object, interaction_type, item, amount)
	
	return nearest


func _determine_potential_interaction(object: Node, inventory: CharacterInventory) -> Target:
	var potential_interaction: Target = null
	if interaction_area:
		potential_interaction = interaction_area.get_potential_interaction(object, inventory)
	else:
		print("InteractionArea is not defined!")
	if potential_interaction:
		return potential_interaction
	
	if _hurt_box:
		potential_interaction = _hurt_box.can_attack_object()
	else:
		print("HurtBox is not defined!")
	return potential_interaction


func _occupied() -> bool:
	return blackboard.current_interaction and blackboard.current_interaction.type


func _set_current_job(new_job) -> void:
	current_job = new_job
	# warning-ignore:return_value_discarded
	_inventory.add(current_job.tool_resource)

func _set_current_interaction(new_interaction: Target) -> void:
	var current_interaction: Target = blackboard.current_interaction
	if current_interaction == new_interaction:
		return
	
	if current_interaction and _node_is_dibbable(current_interaction.node):
		# warning-ignore:unsafe_method_access
		current_interaction.node.call_dibs(self, false)
	
	current_interaction = new_interaction
	blackboard.emit_signal("current_interaction_changed", current_interaction)
	
	if current_interaction and _node_is_dibbable(current_interaction.node):
		# warning-ignore:unsafe_method_access
		current_interaction.node.call_dibs(self, true)

func _set_nearest_interaction(new_interaction: Target) -> void:
	var nearest_interaction: Target = blackboard.nearest_interaction
	if nearest_interaction == new_interaction:
		return
	
	if nearest_interaction and _node_is_dibbable(nearest_interaction.node):
		# warning-ignore:unsafe_method_access
		nearest_interaction.node.call_dibs(self, false)
	
	nearest_interaction = new_interaction
	blackboard.emit_signal("nearest_interaction_changed", nearest_interaction)
	
	if nearest_interaction and _node_is_dibbable(nearest_interaction.node):
		# warning-ignore:unsafe_method_access
		nearest_interaction.node.call_dibs(self, true)

func _node_is_dibbable(node: Node) -> bool:
	return node != null and node.has_method("call_dibs")



func _create_blackboard() -> CharacterBlackboard:
	var character: Character = owner
	return CharacterBlackboard.new(
		self,
		character,
		get_node(_inventory_node),
		get_node(_perception_area_node),
		get_node(_interaction_area_node),
		get_node(_hurt_box_node),
		character.get_navigation().spotted_items,
		current_job
	)



class CharacterBlackboard extends BehaviorTree.Blackboard:
	signal current_interaction_changed(interaction)
	signal nearest_interaction_changed(interaction)
	
	var character: Character
	var inventory: CharacterInventory
	# WAITFORUPDATE: specify type after 4.0
	var perception_area: Area #PerceptionArea
	# WAITFORUPDATE: specify type after 4.0
	var interaction_area: Area #InteractionArea
	# WAITFORUPDATE: specify type after 4.0
	var hurt_box: Area #HurtBox
	var spotted_items: SpottedItems
	
	var job: Workstation.Job
	var current_interaction: Target = null
	var nearest_interaction: Target = null
	
	func _init(
		new_behavior_tree_root: BehaviorTreeRoot,
		new_character: Character,
		new_inventory: CharacterInventory,
		# WAITFORUPDATE: specify type after 4.0
		new_perception_area: Area, #PerceptionArea,
		# WAITFORUPDATE: specify type after 4.0
		new_interaction_area: Area, #InteractionArea,
		# WAITFORUPDATE: specify type after 4.0
		new_hurt_box: Area, #HurtBox,
		new_spotted_items: SpottedItems,
		new_job: Workstation.Job
	).(new_behavior_tree_root) -> void:
		character = new_character
		inventory = new_inventory
		perception_area = new_perception_area
		interaction_area = new_interaction_area
		hurt_box = new_hurt_box
		spotted_items = new_spotted_items
		job = new_job


class Target:
	var node: Spatial
	
	func _init(new_node: Spatial) -> void:
		node = new_node
	
	func position() -> Vector3:
		return node.global_transform.origin

class ItemInteraction extends Target:
	var type: int
	var item_resource: ItemResource
	var item_amount: int
	
	func _init(new_node: Spatial, new_type: int, new_resource: ItemResource, new_item_amount: int).(new_node) -> void:
		type = new_type
		item_resource = new_resource
		item_amount = new_item_amount

class ObjectInteraction extends Target:
	var type: int
	
	func _init(new_node: Spatial, new_type: int).(new_node) -> void:
		type = new_type
