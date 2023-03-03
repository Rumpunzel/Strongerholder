class_name StateNode
extends Node

var transitions: Array

# warning-ignore:unused_class_variable
onready var _character: Character = owner


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
