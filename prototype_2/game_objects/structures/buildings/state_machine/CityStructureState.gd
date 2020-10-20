class_name CityStructureState
extends ObjectState


const GIVE = "give"
const TAKE = "take"



func exit(next_state: String, parameter: Array = [ ]):
	if _animation_cancellable:
		.exit(next_state, parameter)




func give_item(item: GameResource, receiver: Node2D):
	exit(GIVE, [item, receiver])


func take_item(item: GameResource):
	exit(TAKE, [item])
