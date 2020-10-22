class_name CityStructureStateMachine, "res://assets/icons/structures/icon_city_structure_state_machine.svg"
extends ObjectStateMachine



func give_item(item: GameResource, receiver: Node2D):
	current_state.give_item(item, receiver)


func take_item(item: GameResource):
	current_state.take_item(item)
