class_name CharacterBlackboard
extends Blackboard

signal current_interaction_changed(interaction)
signal nearest_interaction_changed(interaction)

var character: Character
# WAITFORUPDATE: specify type after 4.0
var interaction_area: Area #InteractionArea
# WAITFORUPDATE: specify type after 4.0
var hurt_box: Area #HurtBox
var animation_tree: AnimationTree

# WAITFORUPDATE: specify type after 4.0 : CharacterController.Target
var current_interaction = null setget set_current_interaction
# WAITFORUPDATE: specify type after 4.0 : CharacterController.Target
var nearest_interaction = null setget set_nearest_interaction


func _init(
	new_behavior_tree: BehaviorTree,
	new_character: Character,
	# WAITFORUPDATE: specify type after 4.0
	new_interaction_area: Area, #InteractionArea,
	# WAITFORUPDATE: specify type after 4.0
	new_hurt_box: Area, #HurtBox,
	new_animation_tree: AnimationTree
).(new_behavior_tree) -> void:
	character = new_character
	interaction_area = new_interaction_area
	hurt_box = new_hurt_box
	animation_tree = new_animation_tree


# WAITFORUPDATE: specify type after 4.0
func set_current_interaction(new_interaction) -> void:#: CharacterController.Target) -> void:
	if current_interaction == new_interaction:
		return
	
	if current_interaction:
		undib_node(current_interaction.node, character)
	
	current_interaction = new_interaction
	emit_signal("current_interaction_changed", current_interaction)
	
	if current_interaction:
		dib_node(current_interaction.node, character)

# WAITFORUPDATE: specify type after 4.0
func set_nearest_interaction(new_interaction) -> void:#: CharacterController.Target) -> void:
	if nearest_interaction == new_interaction:
		return
	
	nearest_interaction = new_interaction
	emit_signal("nearest_interaction_changed", nearest_interaction)


func reset() -> void:
	set_current_interaction(null)


static func dib_node(node: Node, for_character: Character) -> void:
	if node_is_dibbable(node):
		# warning-ignore:unsafe_method_access
		node.call_dibs(for_character, true)

static func undib_node(node: Node, for_character: Character) -> void:
	if node_is_dibbable(node):
		# warning-ignore:unsafe_method_access
		node.call_dibs(for_character, false)

static func node_is_dibbable(node: Node) -> bool:
	return node != null and node.has_method("call_dibs")
