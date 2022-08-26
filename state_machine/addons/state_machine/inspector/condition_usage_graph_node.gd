extends "res://addons/state_machine/inspector/grapgh_node.gd"
tool

var condition_usage_resource: ConditionUsageResource setget set_condition_usage_resource


func set_condition_usage_resource(new_condition_usage_resource: ConditionUsageResource) -> void:
	condition_usage_resource = new_condition_usage_resource
	
	var condition_name: String = condition_usage_resource.condition.resource_path.get_file().get_basename()
	var expected_result := condition_usage_resource.expected_result
	var operator: int = condition_usage_resource.operator
	
	_update_title()
	$HBoxContainer/Condition.text = condition_name
	$HBoxContainer/ExpectedResult.pressed = expected_result
	$Operator.update_style(operator)


func _update_title() -> void:
	var condition_name: String = condition_usage_resource.condition.resource_path.get_file().get_basename()
	var expected_result := condition_usage_resource.expected_result
	var operator: int = condition_usage_resource.operator
	title = "%s: %s [%s]" % [ condition_name.capitalize(), expected_result, ConditionUsageResource.Operator.keys()[operator] ]
	$HBoxContainer/Condition.text = condition_name


func _on_condition_button_pressed() -> void:
	var file_dialog: FileDialog = $Node/ConditionFileDialog
	file_dialog.current_path = condition_usage_resource.condition.resource_path
	file_dialog.popup_centered()

func _on_condition_file_selected(path: String) -> void:
	var new_condition := load(path)
	if not (new_condition and new_condition is StateConditionResource):
		$Node/ConditionFileDialog.current_path = condition_usage_resource.condition.resource_path
		$Node/AcceptDialog.popup_centered()
		return
	
	condition_usage_resource.condition = new_condition
	_update_title()

func _on_expected_result_changed(new_expected_result: bool) -> void:
	condition_usage_resource.expected_result = new_expected_result
	_update_title()

func _on_operator_changed(new_operator: int) -> void:
	condition_usage_resource.operator = new_operator
	_update_title()
