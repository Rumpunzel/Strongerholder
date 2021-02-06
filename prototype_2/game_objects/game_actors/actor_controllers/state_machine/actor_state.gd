class_name ActorState
extends ObjectState


# warning-ignore:unused_signal
signal moved

# warning-ignore:unused_signal
signal gave_item_to
# warning-ignore:unused_signal
signal dropped_item
# warning-ignore:unused_signal
signal took_item
# warning-ignore:unused_signal
signal item_requested

# warning-ignore:unused_signal
signal attacked
# warning-ignore:unused_signal
signal operated_structure


const RUN := "Run"
const GIVE := "Give"
const TAKE := "Take"
const REQUEST := "Request"
const ATTACK := "Attack"
const OPERATE := "Operate"



func exit(next_state: String, parameter: Array = [ ]) -> void:
	if _animation_cancellable:
		.exit(next_state, parameter)




func move_to(direction: Vector2, _is_sprinting: bool) -> void:
	if direction == Vector2():
		exit(IDLE)
	else:
		exit(RUN)


func give_item(item: GameResource, receiver: Node2D) -> void:
	exit(GIVE, [item, receiver])


func take_item(item: GameResource) -> void:
	exit(TAKE, [item])


func request_item(request, receiver: Node2D) -> void:
	exit(REQUEST, [request, receiver])


func attack(weapon: CraftTool) -> void:
	exit(ATTACK, [weapon])


func operate(structure: CityStructure) -> void:
	exit(OPERATE, [structure])



func animation_acted(_animation: String) -> void:
	pass


func action_finished(_animation: String) -> void:
	pass


func animation_finished(_animation: String) -> void:
	_animation_cancellable = true




func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()) -> void:
	emit_signal("animation_changed", new_animation.to_lower(), new_direction)
