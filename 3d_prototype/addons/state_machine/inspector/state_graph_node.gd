extends "res://addons/state_machine/inspector/graph_node.gd"
tool

signal delete_requested()

var state_resource: StateResource setget set_state_resource
var entry_status := false setget set_entry_status


func set_entry_status(new_entry_node: bool) -> void:
	entry_status = new_entry_node
	if entry_status:
		overlay = OVERLAY_POSITION
	else:
		overlay = OVERLAY_DISABLED

func set_state_resource(new_state_resource: StateResource) -> void:
	state_resource = new_state_resource
	var state_name: String = state_resource.resource_path.get_file().get_basename()
	title = state_name.capitalize()
	$Subtitle.text = state_name
	
	var actions := $Actions
	for action_title in actions.get_children():
		actions.remove_child(action_title)
		action_title.queue_free()
	
	for action_resource in state_resource._actions:
		var action: StateActionResource = action_resource
		var new_action_title := Label.new()
		new_action_title.text = action.resource_path.get_file().get_basename()
		new_action_title.modulate = Color.cornflower
		actions.add_child(new_action_title)

func _on_deleted() -> void:
	emit_signal("delete_requested")
