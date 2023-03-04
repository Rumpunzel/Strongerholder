class_name ActionStateNode, "res://editor_tools/class_icons/nodes/icon_hand.svg"
extends StateNode

export(InteractionArea.InteractionType) var _action_type

onready var _animation_parameter: String

onready var _animation_tree: AnimationTree = _character.get_node("AnimationTree")

func _ready() -> void:
	var action_type := ""
	match _action_type:
		InteractionArea.InteractionType.ATTACK:
			action_type = "attack"
		InteractionArea.InteractionType.GIVE:
			action_type = "give"
		InteractionArea.InteractionType.OPERATE:
			action_type = "operate"
		InteractionArea.InteractionType.PICK_UP:
			action_type = "pick_up"
		InteractionArea.InteractionType.TAKE:
			action_type = "take"
		_:
			assert(false, "This animation is not supported!")
	
	_animation_parameter = "parameters/%s/active" % action_type.to_lower()

func on_state_enter() -> void:
	_animation_tree.set(_animation_parameter, true)

func on_update(_delta: float) -> void:
	_animation_tree.set(_animation_parameter, true)
