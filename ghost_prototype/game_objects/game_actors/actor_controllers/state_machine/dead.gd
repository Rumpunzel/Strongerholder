class_name ActorStateDead, "res://class_icons/states/icon_state_dead.svg"
extends ActorStateInactive




func _ready() -> void:
	name = DEAD




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("died")


func exit(_next_state: String, _parameters: Array = [ ]) -> void:
	pass
