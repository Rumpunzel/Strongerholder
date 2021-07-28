class_name ObjectInteractionResource
extends StateActionResource

export(Resource) var _object_to_interact_with
export(InteractionArea.InteractionType) var _interaction_type
export(Resource) var _interaction_item

export var _global_range := false

func _create_action() -> StateAction:
	return ObjectInteraction.new(_object_to_interact_with, _interaction_type, _interaction_item, _global_range)


class ObjectInteraction extends StateAction:
	var _spotted_items: SpottedItems
	var _interaction_area: InteractionArea
	
	var _object_resource: ObjectResource
	var _interaction_type: int
	var _interaction_item: ItemResource
	var _global_range: bool
	
	
	func _init(object: ObjectResource, interaction_type: int, interaction_item: ItemResource, global_range: bool) -> void:
		_object_resource = object
		_interaction_type = interaction_type
		_interaction_item = interaction_item
		_global_range = global_range
	
	
	func awake(state_machine: Node) -> void:
		var character: Character = state_machine.owner
		_spotted_items = character.get_navigation().spotted_items
		_interaction_area = Utils.find_node_of_type_in_children(character, InteractionArea)
	
	
	func on_update(_delta: float) -> void:
		var array_to_search := [ ]
		if _global_range:
			array_to_search = _interaction_area.get_tree().get_nodes_in_group(_object_resource.name)
		elif _object_resource is ItemResource:
			array_to_search = _spotted_items.get_spotted(_object_resource, _interaction_area)
		
		if _interaction_type == InteractionArea.InteractionType.NONE:
			_interaction_area.smart_interact_with_nearest_object_of_type(_object_resource, array_to_search, false)
		else:
			_interaction_area.interact_with_nearest_object_of_type(_object_resource, array_to_search, _interaction_type, _interaction_item, false)
