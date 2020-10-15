class_name ActorState, "res://assets/icons/game_actors/states/icon_state.svg"
extends ObjectState


const RUN = "run"
const GIVE = "give"
const ATTACK = "attack"


var _animation_cancellable: bool = true



func exit(next_state: String, parameter: Array = [ ]):
	if _animation_cancellable:
		.exit(next_state, parameter)



func animation_acted(_animation: String):
	pass


func action_finished(_animation: String):
	pass


func animtion_finished(_animation: String):
	_animation_cancellable = true


func move_to(direction: Vector2, _is_sprinting: bool):
	exit(RUN)


func give_item_to(receiver: Object, item: Object):
	exit(GIVE, [receiver, item])


func attack(target: Object, weapon: CraftTool):
	exit(ATTACK, [target, weapon])



func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()):
	_state_machine._change_animation(new_animation, new_direction)
