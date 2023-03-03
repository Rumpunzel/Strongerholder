extends "res://addons/state_machine/new_inspector/graph_node.gd"
tool

var state_node_path: NodePath setget set_state_node_path
var entry_status := false setget set_entry_status


func set_entry_status(new_entry_node: bool) -> void:
	entry_status = new_entry_node
	if entry_status:
		overlay = OVERLAY_POSITION
	else:
		overlay = OVERLAY_DISABLED

func set_state_node_path(new_state_node_path: NodePath) -> void:
	state_node_path = new_state_node_path
	$Name.text = state_node_path
