class_name CityStructureStateMachine, "res://class_icons/game_objects/structures/icon_city_structure_state_machine.svg"
extends StructureStateMachine


signal operated



func operate() -> void:
	(current_state as CityStructureState).operate()




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


func _connect_states() -> void:
	._connect_states()
	
	for state in get_children():
		state.connect("operated", self, "_on_operated")



func _on_operated() -> void:
	emit_signal("operated")
