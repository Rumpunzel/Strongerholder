extends GraphNode
tool

enum SlotTypes {
	TO_CONDITION,
	TO_SLOT,
}

var condition_usage_resource: ConditionUsageResource setget set_condition_usage_resource


func _enter_tree() -> void:
	$HBoxContainer/Condition.modulate = Color.coral
	set_slot(0, true, SlotTypes.TO_SLOT, Color.cornflower, true, SlotTypes.TO_CONDITION, Color.coral)


func set_condition_usage_resource(new_condition_usage_resource: ConditionUsageResource) -> void:
	condition_usage_resource = new_condition_usage_resource
	
	var condition_usage_name: String = condition_usage_resource.resource_path.get_file().get_basename()
	title = condition_usage_name.capitalize()
	$Subtitle.text = condition_usage_name
	
	var condition: StateConditionResource = condition_usage_resource.condition
	$HBoxContainer/Condition.text = condition.resource_path.get_file().get_basename()
	
	var expected_result := condition_usage_resource.expected_result
	$HBoxContainer/ExpectedResult.pressed = expected_result
	
	var operator: int = condition_usage_resource.operator
	$Operator.clear()
	for index in ConditionUsageResource.Operator.values():
		$Operator.add_item(ConditionUsageResource.Operator.keys()[index], index)
	$Operator.select(operator)
	$Operator._on_item_selected(operator)


func _on_condition_button_pressed() -> void:
	var file_dialog: FileDialog = $Node/ConditionFileDialog
	file_dialog.current_path = condition_usage_resource.condition.resource_path
	file_dialog.popup_centered()

func _on_condition_changed(new_path: String) -> void:
	var new_condition := load(new_path)
	if not (new_condition and new_condition is StateConditionResource):
		$Node/ConditionFileDialog.current_path = condition_usage_resource.condition.resource_path
		$Node/AcceptDialog.popup_centered()
		return
	
	condition_usage_resource.condition = new_condition
	$HBoxContainer/Condition.text = new_condition.resource_path.get_file().get_basename()

func _on_expected_result_changed(new_expected_result: bool) -> void:
	condition_usage_resource.expected_result = new_expected_result

func _on_operator_changed(new_operator: int) -> void:
	condition_usage_resource.operator = new_operator


func _on_deleted() -> void:
	pass # Replace with function body.
