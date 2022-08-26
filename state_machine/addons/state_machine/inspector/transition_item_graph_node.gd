extends "res://addons/state_machine/inspector/grapgh_node.gd"
tool

const ConditionUsageScene := preload("res://addons/state_machine/inspector/condition_usage.tscn")

var transition_item_resource: TransitionItemResource setget set_transition_item_resource


func check_validity() -> void:
	_update_style()



#func _check_transition_item_node(transition_item_node: TransitionItemGraphNode) -> void:
#	var has_right_connection := false
#	var has_left_connection := false
#	for connection in get_connection_list():
#		if connection.from == transition_item_node.name:
#			has_right_connection = true
#		elif connection.to == transition_item_node.name:
#			has_left_connection = true
#
#	if has_right_connection and has_left_connection:
#		condition_node.self_modulate = Color.white
#	else:
#		condition_node.self_modulate = Color.crimson
#		return
#		print("removing condition_usage: %s because left: %s, right: %s" % [ condition_node.condition_usage_resource, has_left_connection, has_right_connection ])
#		for resource in transition_table._transitions:
#			var transition: TransitionItemResource = resource
#			if transition.conditions.has(condition_node.condition_usage_resource):
#				transition.conditions.erase(condition_node.condition_usage_resource)
#			if transition.conditions.empty():
#				transition_table._transitions.erase(transition)


func _update_style() -> void:
	var has_from_state: bool = transition_item_resource.from_state != null
	var has_to_state: bool = transition_item_resource.to_state != null
	
	var from_state_name := "[ ]"
	var to_state_name := "[ ]"
	if has_from_state:
		from_state_name = transition_item_resource.from_state.resource_path.get_file().get_basename().capitalize()
	if has_to_state:
		to_state_name = transition_item_resource.to_state.resource_path.get_file().get_basename().capitalize()
	
	title = "%s -> %s" % [ from_state_name, to_state_name ]
	if not (has_from_state and has_to_state):
		self_modulate = Color.crimson
	elif transition_item_resource.conditions.empty():
		self_modulate = Color.coral
	else:
		self_modulate = Color.white

func _on_operator_changed(new_operator: int) -> void:
	transition_item_resource.operator = new_operator


func set_transition_item_resource(new_transition_item_resource: TransitionItemResource) -> void:
	transition_item_resource = new_transition_item_resource
	
	var condition_usages := $ConditionUsages
	for child in condition_usages.get_children():
		condition_usages.remove_child(child)
		child.queue_free()
	
	for condition_usage in transition_item_resource.conditions:
		var new_condition_usage_node := ConditionUsageScene.instance()
		condition_usages.add_child(new_condition_usage_node)
		new_condition_usage_node.condition_usage_resource = condition_usage
		condition_usages.add_child(HSeparator.new())
	
	$Operator.update_style(transition_item_resource.operator)
	_update_style()
