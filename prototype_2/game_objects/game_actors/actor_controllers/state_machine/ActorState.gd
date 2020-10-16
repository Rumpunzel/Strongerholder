class_name ActorState
extends ObjectState


const RUN = "run"
const GIVE = "give"
const TAKE = "take"
const ATTACK = "attack"


var _animation_cancellable: bool = true



func exit(next_state: String, parameter: Array = [ ]):
	if _animation_cancellable and not name == next_state:
		.exit(next_state, parameter)




func move_to(direction: Vector2, _is_sprinting: bool):
	exit(RUN)


func give_item(item: GameResource):
	exit(GIVE, [item])


func take_item(item: GameResource):
	exit(TAKE, [item])


func attack(weapon: CraftTool):
	exit(ATTACK, [weapon])




func animation_acted(_animation: String):
	pass


func action_finished(_animation: String):
	pass


func animtion_finished(_animation: String):
	_animation_cancellable = true




func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()):
	_state_machine._change_animation(new_animation, new_direction)
