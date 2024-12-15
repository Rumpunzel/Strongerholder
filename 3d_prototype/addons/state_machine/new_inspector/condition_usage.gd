extends HBoxContainer
tool

signal changed()

var condition_usage_resource: ConditionUsageResource setget set_condition_usage_resource


func set_validity(is_valid: bool) -> void:
	$ExpectedResult.modulate = Color.white if is_valid else Color.crimson


func set_condition_usage_resource(new_condition_usage_resource: ConditionUsageResource) -> void:
	condition_usage_resource = new_condition_usage_resource
	
	var condition_name: String = condition_usage_resource.condition.resource_path.get_file().get_basename()
	var expected_result := condition_usage_resource.expected_result
	
	$Condition.text = condition_name
	$ExpectedResult.pressed = expected_result
	$Node/ConditionFileDialog.current_path = condition_usage_resource.condition.resource_path


func _on_condition_file_selected(path: String) -> void:
	var new_condition := load(path)
	if not (new_condition and new_condition is StateConditionResource):
		$Node/ConditionFileDialog.current_path = condition_usage_resource.condition.resource_path
		$Node/AcceptDialog.popup_centered()
		return
	
	condition_usage_resource.condition = new_condition
	emit_signal("changed")

func _on_expected_result_changed(new_expected_result: bool) -> void:
	condition_usage_resource.expected_result = new_expected_result
	emit_signal("changed")
