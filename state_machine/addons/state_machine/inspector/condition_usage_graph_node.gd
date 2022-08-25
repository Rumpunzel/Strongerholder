extends GraphNode
tool

enum SlotTypes {
	TO_CONDITION,
	TO_SLOT,
}

var condition_usage_resource: ConditionUsageResource setget set_condition_usage_resource


func _init(new_condition_usage_resource: ConditionUsageResource) -> void:
	set_condition_usage_resource(new_condition_usage_resource)
	


func set_condition_usage_resource(new_condition_usage_resource: ConditionUsageResource) -> void:
	clear_all_slots()
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	condition_usage_resource = new_condition_usage_resource
	
	var condition_usage_name: String = condition_usage_resource.resource_path.get_file().get_basename()
	title = condition_usage_name.capitalize()
	
	var new_subtitle := Label.new()
	new_subtitle.text = "Condition Usage: %s" % condition_usage_name
	add_child(new_subtitle)
	set_slot(0, true, SlotTypes.TO_SLOT, Color.cornflower, true, SlotTypes.TO_CONDITION, Color.coral)
	
	add_child(HSeparator.new())
	var expected_result := condition_usage_resource.expected_result
	var condition: StateConditionResource = condition_usage_resource.condition
	var new_condition_title := Label.new()
	var new_expected_result_title := Label.new()
	new_condition_title.text = "Condition: %s" % condition.resource_path.get_file().get_basename()
	new_expected_result_title.text = "Expected Result: %s" % expected_result
	new_condition_title.modulate = Color.limegreen if expected_result else Color.crimson
	new_expected_result_title.modulate = Color.limegreen if expected_result else Color.crimson
	add_child(new_condition_title)
	add_child(new_expected_result_title)
	
	add_child(HSeparator.new())
	var operator: int = condition_usage_resource.operator
	var new_operator_title := Label.new()
	new_operator_title.text = "Operator: %s" % ConditionUsageResource.Operator.keys()[operator]
	new_operator_title.modulate = Color.limegreen if condition_usage_resource.operator == ConditionUsageResource.Operator.OR else Color.crimson
	add_child(new_operator_title)
	
#	for action_resource in condition_usage_resource._actions:
#		add_child(HSeparator.new())
#		var action: StateActionResource = action_resource
#		var new_action_title := Label.new()
#		new_action_title.text = action.resource_path.get_file().get_basename()
#		add_child(new_action_title)
