class_name StateConditionResource
extends Resource


func get_condition(
		state_machine,#: StateMachine,
		expected_result: bool,
		created_instances: Dictionary
) -> StateCondition.Condition:
	
	var condition: StateCondition = created_instances.get(self)
	
	if not condition:
		condition = create_condition()
		condition.origin_resource = self
		created_instances[self] = condition
		condition.awake(state_machine)
	
	return StateCondition.Condition.new(state_machine, condition, expected_result)


func create_condition() -> StateCondition:
	assert(false)
	return null



func _to_string() -> String:
	return resource_path.get_file().get_basename()
