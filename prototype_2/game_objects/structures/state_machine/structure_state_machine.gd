class_name StructureStateMachine, "res://assets/icons/structures/icon_city_structure_state_machine.svg"
extends ObjectStateMachine


const PERSIST_OBJ_PROPERTIES_3 := ["pilot_master"]


signal operated


var pilot_master: InputMaster = null



func _setup_states(state_classes: Array = [ ]) -> void:
	if state_classes.empty():
		state_classes = [
			CityStructureState,
			CityStructureStateGive, 
			CityStructureStateTake,
			CityStructureInactive,
			CityStructureStateDead,
		]
	
	._setup_states(state_classes)
	
	for state in get_children():
		state.pilot_master = pilot_master




func give_item(item: GameResource, receiver: Node2D) -> void:
	current_state.give_item(item, receiver)


func take_item(item: GameResource) -> void:
	current_state.take_item(item)


func operate() -> void:
	if current_state.operate():
		emit_signal("operated")
