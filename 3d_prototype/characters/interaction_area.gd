class_name InteractionArea, "res://editor_tools/class_icons/spatials/icon_slap.svg"
extends Area


signal item_picked_up(item)
signal attacked(started)
signal gave_item(item)

signal object_entered_interaction_area(object)
signal object_exited_interaction_area(object)

signal object_entered_perception_area(object)
signal object_exited_perception_area(object)


enum InteractionType {
	NONE,
	PICK_UP,
	ATTACK,
	GIVE,
	TAKE,
	OPERATE,
}


var objects_in_interaction_range := [ ]
var objects_in_perception_range := [ ]
var current_interaction: Interaction


var _nearest_interaction: Interaction
var _equipped_item: CharacterInventory.EquippedItem


onready var _character: Spatial = owner
onready var _inputs: CharacterMovementInputs = Utils.find_node_of_type_in_children(_character, CharacterMovementInputs, true)
onready var _hurt_box_shape: CollisionShape = $HurtBox/CollisionShape



func _process(_delta: float) -> void:
	if current_interaction and not current_interaction.type == InteractionType.NONE and weakref(current_interaction.node).get_ref():
		_character.look_position = current_interaction.position()



func smart_interact_with_nearest(inventory: CharacterInventory) -> void:
	if _occupied():
		return
	
	var point_to_walk_to := _interact_with_nearest(objects_in_interaction_range, objects_in_perception_range, inventory)
	_inputs.destination_input = point_to_walk_to


func interact_with_nearest_object_of_type(item: ObjectResource) -> void:
	if _occupied():
		return
	
	var interaction_objects := _filter_array_for_type(objects_in_interaction_range, item)
	var perception_objects := _filter_array_for_type(objects_in_perception_range, item)
	
	var point_to_walk_to := _interact_with_nearest(interaction_objects, perception_objects)
	_inputs.destination_input = point_to_walk_to


func interact_with_specific_object(object: Node) -> void:
	if _occupied():
		return
	
	var interaction_objects := [ object ] if objects_in_interaction_range.has(object) else [ ]
	
	var point_to_walk_to := _interact_with_nearest(interaction_objects, [ object ])
	_inputs.destination_input = point_to_walk_to


func reset() -> void:
	current_interaction = null
	_nearest_interaction = null



func _interact_with_nearest(interactable_objects: Array, perceived_objects: Array, inventory: CharacterInventory = null) -> Vector3:
	# Default is no movement at all
	var point_to_walk_to := _character.translation
	
	# If there is a current target
	if _nearest_interaction and not _nearest_interaction.type == InteractionType.NONE:
		# Check if we are in range
		if interactable_objects.has(_nearest_interaction.node):
			current_interaction = _nearest_interaction
		elif perceived_objects.has(_nearest_interaction.node):
			point_to_walk_to = _nearest_interaction.position()
		else:
			reset()
	else:
		# Check if there is an object in the immediate vicinity to interact with
		_nearest_interaction = _find_nearest_smart_interaction(interactable_objects, inventory)
		if _nearest_interaction:
			current_interaction = _nearest_interaction
		else:
			# Check in the broader vicinity
			_nearest_interaction = _find_nearest_smart_interaction(perceived_objects, inventory)
			if _nearest_interaction:
				point_to_walk_to = _nearest_interaction.position()
	
	return point_to_walk_to


func _find_nearest_smart_interaction(objects: Array, inventory: CharacterInventory) -> Interaction:
	var nearest: Interaction = null
	var closest_distance: float = INF
	
	for object in objects:
		if object == owner or object.owner == owner:
			continue
		
		var potential_interaction := Interaction.new(object)
		potential_interaction.type = _determine_interaction_type(object, inventory)
		
		if potential_interaction.type == InteractionType.NONE:
			continue
		
		var distance := _character.translation.distance_squared_to(object.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			nearest = potential_interaction
	
	return nearest


func _determine_interaction_type(object: Node, inventory: CharacterInventory) -> int:
	var interaction_type: int = InteractionType.NONE
	
	if object is CollectableItem:
		interaction_type = InteractionType.PICK_UP
	elif object is Stash and (not inventory or inventory.contains(object.item_to_store)):
		interaction_type = InteractionType.GIVE
	elif object is Workstation:
		pass
	elif object is HitBox and _equipped_item:
		var equipped_tool: ToolResource = _equipped_item.stack.item
		# WAITFORUPDATE: remove this unnecessary thing after 4.0
		# warning-ignore-all:unsafe_property_access
		if object.type & equipped_tool.used_on:
			interaction_type = InteractionType.ATTACK
	
	return interaction_type


func _filter_array_for_type(array: Array, object_type: ObjectResource) -> Array:
	var filtered_array := [ ]
	
	for object in array:
		if object is CollectableItem:
			if object.item_resource == object_type:
				filtered_array.append(object)
		elif object is HitBox:
			if object.owner.structure_resource == object_type:
				filtered_array.append(object)
	
	return filtered_array


func _occupied() -> bool:
	return current_interaction and not current_interaction.type == InteractionType.NONE


func _collect() -> void:
	var item_node: CollectableItem = current_interaction.node as CollectableItem
	
	if not item_node:
		return
	
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore-all:unsafe_property_access
	var item: ItemResource = item_node.item_resource
	emit_signal("item_picked_up", item)
	
	# HACK: properly destroy here
	item_node.queue_free()


func _attack(started: bool) -> void:
	_hurt_box_shape.disabled = not started
	emit_signal("attacked", started)


func _give() -> void:
	var stash: Stash = current_interaction.node
	var item: ItemResource = stash.item_to_store
	
	emit_signal("gave_item", item)
	# warning-ignore:return_value_discarded
	stash.stash(item)



func _on_object_entered_perception_area(object: Node) -> void:
	objects_in_perception_range.append(object)
	emit_signal("object_entered_perception_area", object)

func _on_object_exited_perception_area(object: Node) -> void:
	objects_in_perception_range.erase(object)
	emit_signal("object_exited_perception_area", object)


func _on_object_entered_interaction_area(object: Node) -> void:
	objects_in_interaction_range.append(object)
	emit_signal("object_entered_interaction_area", object)

func _on_object_exited_interaction_area(object: Node) -> void:
	objects_in_interaction_range.erase(object)
	emit_signal("object_exited_interaction_area", object)


func _on_hurt_box_entered(area: Area) -> void:
	if not area is HitBox:
		return
	
	var hit_box := area as HitBox
	var equipped_tool: ToolResource = _equipped_item.stack.item
	
	if hit_box.type & equipped_tool.used_on:
		# warning-ignore:return_value_discarded
		hit_box.damage(equipped_tool.damage, self)


func _on_item_equipped(equipment: CharacterInventory.EquippedItem):
	_equipped_item = equipment

func _on_item_unequipped(equipment: CharacterInventory.EquippedItem):
	if _equipped_item == equipment:
		_equipped_item = null



class Interaction:
	var node: Spatial
	var type: int
	
	func _init(new_node: Spatial, new_type := 0) -> void:
		node = new_node
		type = new_type
	
	func position() -> Vector3:
		return node.global_transform.origin
