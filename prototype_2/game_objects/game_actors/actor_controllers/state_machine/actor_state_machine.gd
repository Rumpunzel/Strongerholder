class_name ActorStateMachine, "res://class_icons/states/icon_actor_state_machine.svg"
extends ObjectStateMachine


signal moved

signal gave_item_to
signal dropped_item
signal took_item
signal item_requested

signal attacked
signal operated_structure


var _checked_animation: bool = false





#func _process(_delta: float) -> void:
#	if _checked_animation:
#		return
#
#	var current_animation: String = _animation_tree.get_current_animation()
#
#	if not current_state._animation_cancellable and not (current_animation == ActorState.ATTACK or current_animation == ActorState.GIVE):
#		current_state.animation_finished(current_animation)
#
#	_checked_animation = true




func move_to(direction: Vector2, is_sprinting: bool = false) -> void:
	current_state.move_to(direction, is_sprinting)


func give_item(item: GameResource, receiver: Node2D) -> void:
	current_state.give_item(item, receiver)


func take_item(item: GameResource) -> void:
	current_state.take_item(item)


func request_item(request, receiver: Node2D) -> void:
	current_state.request_item(request, receiver)


func transfer_item(item, receiver: Node2D) -> void:
	current_state.transfer_item(item, receiver)


func attack(weapon: CraftTool) -> void:
	current_state.attack(weapon)


func operate(structure: Node2D) -> void:
	current_state.operate(structure)



func _animation_acted(animation: String) -> void:
	current_state.animation_acted(animation)

func _action_finished(animation: String) -> void:
	current_state.action_finished(animation)

func _animation_finished(animation: String) -> void:
	current_state.animation_finished(animation)



func _setup_states(state_classes: Array = [ ]) -> void:
	if state_classes.empty():
		state_classes = [
			ActorStateIdle,
			ActorStateRun, 
			ActorStateGive,
			ActorStateTake,
			ActorStateRequest,
			ActorStateAttack,
			ActorStateOperate,
			ActorStateInactive,
			ActorStateDead,
		]
	
	._setup_states(state_classes)
	
	for state in get_children():
		state.connect("moved", self, "_on_moved")
		state.connect("gave_item_to", self, "_on_gave_item_to")
		state.connect("dropped_item", self, "_on_dropped_item")
		state.connect("took_item", self, "_on_took_item")
		state.connect("item_requested", self, "_on_item_requested")
		state.connect("attacked", self, "_on_attacked")
		state.connect("operated_structure", self, "_on_operated_structure")



func _on_moved(new_velocity: Vector2, sprinting: bool = false) -> void:
	emit_signal("moved", new_velocity, sprinting)

func _on_gave_item_to(item: GameResource, receiver) -> void:
	emit_signal("gave_item_to", item, receiver)

func _on_dropped_item(item: GameResource) -> void:
	emit_signal("dropped_item", item)

func _on_took_item(item_to_take: GameResource) -> void:
	emit_signal("took_item", item_to_take)

func _on_item_requested(request: GameResource, structure_to_request_from) -> void:
	emit_signal("item_requested", request, structure_to_request_from)

func _on_attacked(weapon: CraftTool) -> void:
	emit_signal("attacked", weapon)

func _on_operated_structure(structure) -> void:
	emit_signal("operated_structure", structure)
