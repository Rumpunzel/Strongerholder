class_name StateNode
extends Node

var transitions: Array

var _character: Character
var _navigation_agent: NavigationAgent
var _interaction_area: InteractionArea
var _animation_tree: AnimationTree
var _movement_stats: CharacterMovementStatsResource


func _ready() -> void:
	_character = owner
	_navigation_agent = _character.get_navigation_agent()
	_interaction_area = Utils.find_node_of_type_in_children(_character, InteractionArea)
	_animation_tree = _character.get_node("AnimationTree")
	_movement_stats = _character.movement_stats


func on_state_enter() -> void:
	pass

func on_update(_delta: float) -> void:
	pass

func on_input(_input: InputEvent) -> void:
	pass

func on_state_exit():
	pass


func try_get_transition() -> NodePath:
	var state_node_path: NodePath = NodePath()
	
	for transition in transitions:
		state_node_path = transition.try_get_transition()
		if not state_node_path.is_empty():
			break
	
	return state_node_path
