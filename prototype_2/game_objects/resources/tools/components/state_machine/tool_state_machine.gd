class_name ToolStateMachine, "res://class_icons/states/icon_tool_state_machine.svg"
extends ResourceStateMachine


signal hit_box_enabled
signal hit_box_disabled



func _setup_states(state_classes: Array = [ ]) -> void:
	if state_classes.empty():
		state_classes = [
			ToolStateInactive,
			ToolState,
			ToolStateAttack,
			ToolStateDead,
		]
	
	._setup_states(state_classes)
	
	for state in get_children():
		state.connect("hit_box_enabled", self, "_on_hit_box_enabled")
		state.connect("hit_box_disabled", self, "_on_hit_box_disabled")




func start_attack(game_actor: Node2D) -> void:#GameActor) -> void:
	current_state.start_attack(game_actor)


func end_attack() -> void:
	current_state.end_attack()



func _on_hit_box_enabled(game_actor: Node2D) -> void:#GameActor) -> void:
	emit_signal("hit_box_enabled", game_actor)

func _on_hit_box_disabled() -> void:
	emit_signal("hit_box_enabled")
