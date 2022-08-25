extends OptionButton
tool

func _on_item_selected(index: int) -> void:
	match index:
		ConditionUsageResource.Operator.AND:
			modulate = Color.crimson
		ConditionUsageResource.Operator.OR:
			modulate = Color.limegreen
		_:
			assert(false, "No Operator defined for index %d!" % index)
