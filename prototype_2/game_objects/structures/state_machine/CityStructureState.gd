class_name CityStructureState
extends ObjectState


const PERSIST_OBJ_PROPERTIES_2 := ["pilot_master"]


const GIVE = "give"
const TAKE = "take"


var pilot_master




func _ready() -> void:
	name = IDLE




func exit(next_state: String, parameter: Array = [ ]) -> void:
	if _animation_cancellable:
		.exit(next_state, parameter)




func give_item(item: GameResource, receiver: Node2D) -> void:
	exit(GIVE, [item, receiver])


func take_item(item: GameResource) -> void:
	exit(TAKE, [item])


func operate() -> bool:
	if pilot_master.can_be_operated():
		pilot_master.refine_resource()
		
		return true
	
	return false
