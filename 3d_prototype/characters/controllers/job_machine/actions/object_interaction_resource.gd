class_name ObjectInteractionResource
extends StateActionResource

export(Resource) var _object_to_interact_with
export var _global_range := false

func _create_action() -> StateAction:
	return ObjectInteraction.new(_object_to_interact_with, _global_range)


class ObjectInteraction extends StateAction:
	var _interaction_area: InteractionArea
	
	var _object_resource: ObjectResource
	var _global_range: bool
	
	
	func _init(object: ObjectResource, global_range: bool) -> void:
		_object_resource = object
		_global_range = global_range
	
	
	func awake(state_machine: Node) -> void:
		_interaction_area = Utils.find_node_of_type_in_children(state_machine.owner, InteractionArea)
	
	
	func on_update(_delta: float) -> void:
		_interaction_area.interact_with_nearest_object_of_type(_object_resource, _global_range)
