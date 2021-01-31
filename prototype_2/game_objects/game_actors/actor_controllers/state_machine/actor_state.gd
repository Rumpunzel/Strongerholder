class_name ActorState
extends ObjectState


const PERSIST_OBJ_PROPERTIES_2 := ["puppet_master"]


const RUN = "run"
const GIVE = "give"
const TAKE = "take"
const REQUEST = "request"
const ATTACK = "attack"
const OPERATE = "operate"


# warning-ignore-all:unused_class_variable
var puppet_master: InputMaster = null



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


func operate(structure: Structure) -> void:
	exit(OPERATE, [structure])



func animation_acted(_animation: String) -> void:
	pass


func action_finished(_animation: String) -> void:
	pass


func animtion_finished(_animation: String) -> void:
	_animation_cancellable = true




func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()) -> void:
	state_machine._change_animation(new_animation, new_direction)
