extends GraphNode
tool

enum SlotTypes {
	TO_CONDITION,
	TO_SLOT,
}

var state_resource: StateResource setget set_state_resource


func _init(new_state_resource: StateResource) -> void:
	set_state_resource(new_state_resource)
	


func set_state_resource(new_state_resource: StateResource) -> void:
	clear_all_slots()
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	state_resource = new_state_resource
	var state_name: String = state_resource.resource_path.get_file().get_basename()
	title = state_name.capitalize()
	
	var new_subtitle := Label.new()
	new_subtitle.text = state_name
	add_child(new_subtitle)
	set_slot(0, true, SlotTypes.TO_CONDITION, Color.coral, true, SlotTypes.TO_SLOT, Color.cornflower)
	
	for action_resource in state_resource._actions:
		add_child(HSeparator.new())
		var action: StateActionResource = action_resource
		var new_action_title := Label.new()
		new_action_title.text = action.resource_path.get_file().get_basename()
		add_child(new_action_title)
