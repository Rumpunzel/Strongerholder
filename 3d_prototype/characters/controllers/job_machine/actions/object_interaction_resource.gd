class_name ObjectInteractionResource
extends StateActionResource

export(Resource) var object_to_interact_with

func _create_action() -> StateAction:
	return ObjectInteraction.new(object_to_interact_with)


class ObjectInteraction extends StateAction:
	var _character: Character
	var _inputs: CharacterMovementInputs
	var _interaction_area: InteractionArea
	
	var _object_resource: ObjectResource
	
	
	func _init(object: ObjectResource) -> void:
		_object_resource = object
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_inputs = Utils.find_node_of_type_in_children(_character, CharacterMovementInputs)
		_interaction_area = Utils.find_node_of_type_in_children(_character, InteractionArea)
	
	
	func on_update(_delta: float) -> void:
		_interaction_area.interact_with_nearest(_object_resource)
	
	func on_state_exit() -> void:
		_inputs.destination_input = _character.translation
