extends "res://addons/state_machine/inspector/grapgh_node.gd"
tool

const ConditionUsageScene := preload("res://addons/state_machine/inspector/condition_usage.tscn")

var transition_item_resource: TransitionItemResource setget set_transition_item_resource


func check_validity() -> void:
	_update_style()


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
	
	$Operator.update_style(transition_item_resource.operator)
	_update_style()
