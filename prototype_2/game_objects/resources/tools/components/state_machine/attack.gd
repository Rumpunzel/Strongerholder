class_name ToolStateAttack, "res://class_icons/states/icon_state_attack.svg"
extends ToolStateInactive




func _ready() -> void:
	name = ATTACK




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	if not parameters.empty():
		emit_signal("hit_box_enabled", parameters[0])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	emit_signal("hit_box_disabled")
	
	.exit(next_state, parameters)



func end_attack() -> void:
	exit(INACTIVE)
