class_name ObjectInteractionResource
extends StateActionResource

export(Resource) var object_to_interact_with

func _create_action() -> StateAction:
	return ObjectInteraction.new(object_to_interact_with)


class ObjectInteraction extends StateAction:
	var _interaction_area: InteractionArea
	
	var _object_resource: ObjectResource
	
	
	func _init(object: ObjectResource) -> void:
		_object_resource = object
	
	
	func awake(state_machine: Node) -> void:
		_interaction_area = Utils.find_node_of_type_in_children(state_machine.owner, InteractionArea)
	
	
	func on_update(_delta: float) -> void:
		_interaction_area.smart_interact_with_nearest(_object_resource)
