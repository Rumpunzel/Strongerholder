class_name ActionStateNode, "res://editor_tools/class_icons/nodes/icon_muscle_up.svg"
extends StateNode

export(NodePath) var _character_controller_node
export(NodePath) var _animation_tree_node

var _animation_parameter: String

onready var _character_controller: CharacterController = get_node(_character_controller_node)
onready var _animation_tree: AnimationTree = get_node(_animation_tree_node)


func on_state_enter() -> void:
	_animation_parameter = translate_interaction_to_parameter(_character_controller.blackboard.current_interaction)
	_animation_tree.set(_animation_parameter, true)

func on_update(_delta: float) -> void:
	_animation_parameter = translate_interaction_to_parameter(_character_controller.blackboard.current_interaction)
	_animation_tree.set(_animation_parameter, true)


static func translate_interaction_to_parameter(interaction: CharacterController.Target) -> String:
	var animation_parameter := "parameters/%s/active"
	
	if interaction is CharacterController.ItemInteraction:
		return animation_parameter % _translate_item_interaction(interaction.type)
	
	if interaction is CharacterController.ObjectInteraction:
		return animation_parameter % _translate_object_interaction(interaction.type)
	
	assert(false, "The provided Target was neither ItemInteraction nor ObjectInteraction!")
	return ""

static func _translate_item_interaction(interaction_type: int) -> String:
	match interaction_type:
		CharacterController.InteractionType.GIVE:
			return "give"
		CharacterController.InteractionType.TAKE:
			return "take"
		_:
			assert(false, "This animation is not supported for ItemInteractions!")
	
	return ""

static func _translate_object_interaction(interaction_type: int) -> String:
	match interaction_type:
		CharacterController.InteractionType.ATTACK:
			return "attack"
		CharacterController.InteractionType.OPERATE:
			return "operate"
		CharacterController.InteractionType.PICK_UP:
			return "pick_up"
		_:
			assert(false, "This animation is not supported for ObjectInteractions!")
	
	return ""
