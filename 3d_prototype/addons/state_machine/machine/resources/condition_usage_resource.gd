class_name ConditionUsageResource, "res://addons/state_machine/icons/icon_choice.svg"
extends Resource

# warning-ignore-all:unused_class_variable
export(Resource) var condition#: StateConditionResource
export var expected_result := true

func _to_string() -> String:
	return "(Condition: %s, Expected Result: %s)" % [ condition, expected_result ]
