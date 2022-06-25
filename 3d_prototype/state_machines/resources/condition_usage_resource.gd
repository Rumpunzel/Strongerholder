class_name ConditionUsageResource, "res://editor_tools/class_icons/resources/icon_choice.svg"
extends Resource

enum Operator { AND, OR }

# warning-ignore-all:unused_class_variable
export(Resource) var condition#: StateConditionResource
export var expected_result := true
export(Operator) var operator = Operator.AND#: int # Operator


func _to_string() -> String:
	return "(Expected Result: %s, Condition: %s, Operator: %s)" % [ expected_result, condition, operator ]
