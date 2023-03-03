extends "res://addons/state_machine/new_inspector/graph_node.gd"
tool

signal delete_requested()

var state_resource: NodePath setget set_state_resource
var entry_status := false setget set_entry_status


func set_entry_status(new_entry_node: bool) -> void:
	entry_status = new_entry_node
	if entry_status:
		overlay = OVERLAY_POSITION
	else:
		overlay = OVERLAY_DISABLED

func set_state_resource(new_state_resource: NodePath) -> void:
	state_resource = new_state_resource
	$Subtitle.text = state_resource

func _on_deleted() -> void:
	emit_signal("delete_requested")
