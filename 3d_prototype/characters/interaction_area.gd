class_name InteractionArea
extends Area

enum InteractionType {
	NONE,
	PICK_UP,
	ATTACK,
}

var _objects_in_perception_range: Array = [ ]

var _objects_in_interaction_range: Array = [ ]
var _nearest_interaction: Interaction

var current_interaction: Interaction

onready var _character: Character = owner as Character



func _process(_delta: float) -> void:
	_nearest_interaction = null
	if Input.is_action_pressed("interact"):
		_interact_with_nearest()
	
	if Input.is_action_just_released("interact"):
		if current_interaction and not current_interaction.type == InteractionType.NONE:
			_character.destination_input = transform.origin


func _interact_with_nearest() -> void:
	_nearest_interaction = _find_nearest_interaction(_objects_in_interaction_range)
	if _nearest_interaction:
		current_interaction = _nearest_interaction
		_character.destination_input = transform.origin
		return
	
	_nearest_interaction = _find_nearest_interaction(_objects_in_perception_range)
	if _nearest_interaction:
		_character.destination_input = _nearest_interaction.node.transform.origin
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
		
		var distance := transform.origin.distance_squared_to(object.transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			nearest = potential_interaction
	
	return nearest



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