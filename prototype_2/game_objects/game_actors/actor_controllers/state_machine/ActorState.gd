class_name ActorState
extends ObjectState


const RUN = "run"
const GIVE = "give"
const TAKE = "take"
const REQUEST = "request"
const ATTACK = "attack"
const OPERATE = "operate"



func exit(next_state: String, parameter: Array = [ ]):
	if _animation_cancellable:
		.exit(next_state, parameter)




func move_to(direction: Vector2, _is_sprinting: bool):
	if direction == Vector2():
		exit(IDLE)
	else:
		exit(RUN)


func give_item(item: GameResource, receiver: Node2D):
	exit(GIVE, [item, receiver])


func take_item(item: GameResource):
	exit(TAKE, [item])


func request_item(request, receiver: Node2D):
	exit(REQUEST, [request, receiver])


func attack(weapon: CraftTool):
	exit(ATTACK, [weapon])


func operate(structure: Structure):
	exit(OPERATE, [structure])



func animation_acted(_animation: String):
	pass


func action_finished(_animation: String):
	pass


func animtion_finished(_animation: String):
	_animation_cancellable = true




func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()):
	_state_machine._change_animation(new_animation, new_direction)
