class_name InteractionArea
extends Area

signal item_picked_up(item)

enum InteractionType {
	NONE,
	PICK_UP,
	ATTACK,
}

var _objects_in_perception_range: Array = [ ]

var _objects_in_interaction_range: Array = [ ]
var _nearest_interaction: Interaction

var current_interaction: Interaction

var _character: Spatial
var _inputs: CharacterMovementInputs



func _ready() -> void:
	_character = owner
	_inputs = _character.get_inputs()


func _process(_delta: float) -> void:
	_nearest_interaction = null
	if Input.is_action_pressed("interact"):
		_interact_with_nearest()
	
	if Input.is_action_just_released("interact"):
		if current_interaction and not current_interaction.type == InteractionType.NONE:
			_inputs.destination_input = _character.translation



func _interact_with_nearest() -> void:
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
		var potential_interaction := Interaction.new(object)
		
		if object.is_in_group("Item"):
			potential_interaction.type = InteractionType.PICK_UP
		elif object.is_in_group("Tree"):
			potential_interaction.type = InteractionType.ATTACK
		
		if potential_interaction.type == InteractionType.NONE:
			continue
		
		var distance := translation.distance_squared_to(object.translation)
		if distance < closest_distance:
			closest_distance = distance
			nearest = potential_interaction
	
	return nearest



func _collect() -> void:
	var item_node: CollectableItem = current_interaction.node as CollectableItem
	var item: ItemResource = item_node.item_resource
	emit_signal("item_picked_up", item)
	
	current_interaction = null
	# HACK: properly destroy here
	item_node.queue_free()




func _on_body_entered_perception_area(body: Node) -> void:
	_objects_in_perception_range.append(body)

func _on_body_exited_perception_area(body: Node) -> void:
	_objects_in_perception_range.erase(body)


func _on_body_entered_interaction_area(body: Node) -> void:
	_objects_in_interaction_range.append(body)

func _on_body_exited_interaction_area(body: Node) -> void:
	_objects_in_interaction_range.erase(body)




class Interaction:
	var node: Spatial
	var type: int
	
	func _init(new_node: Spatial, new_type: int = 0) -> void:
		node = new_node
		type = new_type
