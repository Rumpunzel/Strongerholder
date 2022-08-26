extends Button
tool

signal value_changed(value)

var _button_styles := {
	ConditionUsageResource.Operator.AND: ButtonStyle.new("AND", Color.crimson),
	ConditionUsageResource.Operator.OR: ButtonStyle.new("OR", Color.limegreen),
}

var _value: int = 0


func update_style(new_value: int) -> void:
	_value = new_value
	_value %= _button_styles.size()
	var new_style: ButtonStyle = _button_styles[_value]
	text = new_style.button_text
	modulate = new_style.button_modulate

func _on_pressed() -> void:
	update_style(_value + 1)
	emit_signal("value_changed", _value)


class ButtonStyle:
	var button_text: String
	var button_modulate: Color
	
	func _init(new_text: String, new_modulate: Color) -> void:
		button_text = new_text
		button_modulate = new_modulate
