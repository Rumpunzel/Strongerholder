class_name StructureStateDead, "res://class_icons/states/icon_state_dead.svg"
extends StructureInactive




func _ready() -> void:
	name = DEAD




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("died")


func exit(_next_state: String, _parameters: Array = [ ]) -> void:
	pass

