class_name InteractionArea, "res://editor_tools/class_icons/spatials/icon_slap.svg"
extends Area

signal item_picked_up(item)
signal attacked(started)

enum InteractionType {
	NONE,
	PICK_UP,
	ATTACK,
}

var _objects_in_perception_range: Array = [ ]

var _objects_in_interaction_range: Array = [ ]
var _nearest_interaction: Interaction

var current_interaction: Interaction

var _equipped_item: CharacterInventory.EquippedItem

onready var _character: Spatial = owner
# warning-ignore:unsafe_method_access
onready var _inputs: CharacterMovementInputs = _character.get_inputs()
onready var _hurt_box_shape: CollisionShape = $HurtBox/CollisionShape


#func _process(_delta: float) -> void:
#	if current_interaction and not current_interaction.type == InteractionType.NONE:
#		_character.look_position = current_interaction.node.translation


func interact_with_nearest() -> void:
	if current_interaction and not current_interaction.type == InteractionType.NONE:
		return
	
	_nearest_interaction = _find_nearest_interaction(_objects_in_interaction_range)
	if _nearest_interaction:
		current_interaction = _nearest_interaction
		_inputs.destination_input = _character.translation
		return
	
	_nearest_interaction = _find_nearest_interaction(_objects_in_perception_range)
	if _nearest_interaction:
		_inputs.destination_input = _nearest_interaction.node.translation
		return


func _find_nearest_interaction(objects: Array) -> Interaction:
	var nearest: Interaction = null
	var closest_distance: float = INF
	
	for object in objects:
		if object == owner:
			continue
		
		var potential_interaction := Interaction.new(object)
		
		if object.is_in_group("Item"):
			potential_interaction.type = InteractionType.PICK_UP
		elif _equipped_item:
			# WAITFORUPDATE: remove this unnecessary thing after 4.0
			# warning-ignore-all:unsafe_property_access
			for use in _equipped_item.stack.item.used_on:
				if object.is_in_group(use):
					potential_interaction.type = InteractionType.ATTACK
					break
		
		if potential_interaction.type == InteractionType.NONE:
			continue
		
		var distance := translation.distance_squared_to(object.translation)
		if distance < closest_distance:
			closest_distance = distance
			nearest = potential_interaction
	
	return nearest


func _collect() -> void:
	var item_node: CollectableItem = current_interaction.node as CollectableItem
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore-all:unsafe_property_access
	var item: ItemResource = item_node.item_resource
	
	current_interaction = null
	emit_signal("item_picked_up", item)
	
	# HACK: properly destroy here
	item_node.queue_free()


func _attack(started: bool) -> void:
	current_interaction = null
	_hurt_box_shape.disabled = not started
	emit_signal("attacked", started)



func _on_body_entered_perception_area(body: Node) -> void:
	_objects_in_perception_range.append(body)

func _on_body_exited_perception_area(body: Node) -> void:
	_objects_in_perception_range.erase(body)


func _on_body_entered_interaction_area(body: Node) -> void:
	_objects_in_interaction_range.append(body)

func _on_body_exited_interaction_area(body: Node) -> void:
	_objects_in_interaction_range.erase(body)


func _on_hurt_box_entered(area: Area) -> void:
	if not area is HitBox:
		return
	
	var hit_box := area as HitBox
	var equipped_tool: ToolResource = _equipped_item.stack.item
	
	for other_group in hit_box.owner.get_groups():
		if equipped_tool.used_on.has(other_group):
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
	
	func _init(new_node: Spatial, new_type: int = 0) -> void:
		node = new_node
		type = new_type
