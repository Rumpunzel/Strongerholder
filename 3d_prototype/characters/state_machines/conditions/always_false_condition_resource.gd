class_name AlwaysFalseConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return AlwaysFalseCondition.new()


class AlwaysFalseCondition extends StateCondition:
	func _statement():
		return false
