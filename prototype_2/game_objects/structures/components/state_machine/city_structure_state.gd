class_name CityStructureState
extends ObjectState


const PERSIST_OBJ_PROPERTIES_2 := ["pilot_master"]


signal operated
# warning-ignore:unused_signal
signal item_dropped
# warning-ignore:unused_signal
signal took_item
# warning-ignore:unused_signal
signal item_transferred


const GIVE := "Give"
const TAKE := "Take"




func _ready() -> void:
	name = IDLE




func exit(next_state: String, parameter: Array = [ ]) -> void:
	if _animation_cancellable:
		.exit(next_state, parameter)




func give_item(item: GameResource, receiver: Node2D) -> void:
	exit(GIVE, [item, receiver])


func take_item(item: GameResource) -> void:
	exit(TAKE, [item])


func operate() -> void:
	emit_signal("operated")
