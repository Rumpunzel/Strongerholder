class_name StructureStateMachine, "res://class_icons/game_objects/structures/icon_city_structure_state_machine.svg"
extends ObjectStateMachine


const PERSIST_OBJ_PROPERTIES_3 := ["pilot_master"]


signal operated
signal item_dropped
signal took_item



func give_item(item: GameResource, receiver: Node2D) -> void:
	current_state.give_item(item, receiver)


func take_item(item: GameResource) -> void:
	current_state.take_item(item)


func operate() -> void:
	current_state.operate()




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
		state.connect("operated", self, "_on_operated")
		state.connect("item_dropped", self, "_on_item_dropped")
		state.connect("took_item", self, "_on_took_item")



func _on_operated() -> void:
	emit_signal("operated")

func _on_item_dropped(item_to_drop: GameResource) -> void:
	emit_signal("item_dropped", item_to_drop)

func _on_took_item(item_to_take: GameResource) -> void:
	emit_signal("took_item", item_to_take)
