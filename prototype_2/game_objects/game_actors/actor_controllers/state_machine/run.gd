class_name ActorStateRun, "res://class_icons/states/icon_state_run.svg"
extends ActorState




func _ready() -> void:
	name = RUN




func exit(next_state: String, parameters: Array = [ ]) -> void:
	emit_signal("moved", Vector2())
	
	.exit(next_state, parameters)



func move_to(direction: Vector2, is_sprinting: bool) -> void:
	if direction == Vector2():
		exit(IDLE)
		return
	
	emit_signal("moved", direction.normalized(), is_sprinting)
	
	_change_animation(RUN, direction)
