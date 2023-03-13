class_name CharacterController
extends BehaviorTree

signal attacked(started)
signal item_picked_up(item)
signal gave_item(item, amount)
signal took_item(item, amount)
signal operated()

signal item_equipped(equipment)
signal item_unequipped(equipment)

export(NodePath) var _hurt_box_node
export(NodePath) var _inventory_node
export(NodePath) var _animation_tree_node
export(NodePath) var _hand_position
export var _equip_first_item := true

var _equipped_item := EquippedItem.new()

onready var _hurt_box: HurtBox = get_node(_hurt_box_node)
onready var _inventory: Inventory = get_node(_inventory_node)
onready var _animation_tree: AnimationTree = get_node(_animation_tree_node)


func _ready() -> void:
	_inventory.connect("equipment_stack_added", self, "_on_equipment_stack_added")
	_blackboard = CharacterBlackboard.new(self, owner, _animation_tree_node)


func get_potential_interaction(object: Node) -> Target:
	var interaction_resource: ItemResource = null
	
	if object is CollectableItem:
		return ItemInteraction.new(object, ObjectInteraction.InteractionType.PICK_UP, interaction_resource, 1)
	
	if object is Stash:
		return ItemInteraction.new(object, ItemInteraction.InteractionType.TRADE, interaction_resource, 1)
	
	if object is Workstation and (object as Workstation).can_be_operated():
		return ItemInteraction.new(object, ObjectInteraction.InteractionType.OPERATE, interaction_resource, 1)
	
	if _hurt_box.can_attack_object(object, _equipped_item.stack.item):
		return ObjectInteraction.new(object, ObjectInteraction.InteractionType.ATTACK)
	
	return null


func attack(started: bool) -> void:
	if started:
		_hurt_box.damage_hit_boxes(_equipped_item.stack.item)
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






func equip_item_stack(equipment_stack: Inventory.ItemStack) -> void:
	assert(get_node(_hand_position))
	
	# warning-ignore:return_value_discarded
	unequip()
	
	_equipped_item.set_stack(_inventory.item_slots.find(equipment_stack), equipment_stack, get_node(_hand_position))
	emit_signal("item_equipped", _equipped_item)


func unequip() -> bool:
	if _equipped_item.stack_id >= 0:
		emit_signal("item_unequipped", _equipped_item)
		_equipped_item.unequip()
		return true
	
	return false


func has_equipped(equipment_stack: Inventory.ItemStack) -> bool:
	# TODO: make this a nicer check
	return equipment_stack and equipment_stack == _inventory.item_slots[_equipped_item.stack_id]

func has_something_equipped() -> bool:
	return _equipped_item.stack_id >= 0


func save_to_var(save_file: File) -> void:
	.save_to_var(save_file)
	# Save as data
	save_file.store_8(_equipped_item.stack_id)

func load_from_var(save_file: File) -> void:
	.load_from_var(save_file)
	# Load as data and equip
	var current_stack_id: int = save_file.get_8()
	if current_stack_id >= 0 and current_stack_id < _inventory.item_slots.size():
		equip_item_stack(_inventory.item_slots[current_stack_id])


func _on_equipment_stack_added(new_equipment_stack: Inventory.ItemStack) -> void:
	if _equip_first_item and _equipped_item.stack_id < 0:
		equip_item_stack(new_equipment_stack)


func _get_configuration_warning() -> String:
	var warning := ._get_configuration_warning()
	if not _hand_position:
		warning = "HandPosition path is required"
	
	return warning



class EquippedItem:
	var stack_id: int = -1
	var stack: Inventory.ItemStack = Inventory.ItemStack.new(null)
	var node: Spatial = null
	
	func unequip() -> void:
		stack_id = -1
		stack = Inventory.ItemStack.new(null)
		if node:
			node.queue_free()
			node = null
	
	func set_stack(new_stack_id: int, new_stack: Inventory.ItemStack, hand_position: Spatial) -> void:
		assert(new_stack)
		assert(hand_position)
		stack_id = new_stack_id
		
		stack = new_stack
		if stack.item:
			node = stack.item.attach_to(hand_position)
		elif node:
			node.queue_free()
			node = null






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
