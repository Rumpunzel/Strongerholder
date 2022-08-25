extends GraphNode
tool

enum SlotTypes {
	TO_CONDITION,
	TO_SLOT,
}

var state_resource: StateResource setget set_state_resource

var _action_titles := [ ]


func _enter_tree() -> void:
	set_slot(0, true, SlotTypes.TO_CONDITION, Color.coral, true, SlotTypes.TO_SLOT, Color.cornflower)


func set_state_resource(new_state_resource: StateResource) -> void:
	state_resource = new_state_resource
	var state_name: String = state_resource.resource_path.get_file().get_basename()
	title = state_name.capitalize()
	
	$Subtitle.text = state_name
	
	for action_title in _action_titles:
		remove_child(action_title)
		action_title.queue_free()
	_action_titles.clear()
	
	for action_resource in state_resource._actions:
		var action: StateActionResource = action_resource
		var new_action_title := Label.new()
		new_action_title.text = action.resource_path.get_file().get_basename()
		new_action_title.modulate = Color.cornflower
		add_child(new_action_title)
		_action_titles.append(new_action_title)


func _on_deleted() -> void:
	pass # Replace with function body.
