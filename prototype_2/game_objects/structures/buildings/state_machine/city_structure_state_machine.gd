class_name CityStructureStateMachine, "res://assets/icons/structures/icon_city_structure_state_machine.svg"
extends ObjectStateMachine


signal operated


export(NodePath) var _pilot_master_node


onready var _pilot_master: CityPilotMaster = get_node(_pilot_master_node)




func _ready():
	for state in get_children():
		state.pilot_master = _pilot_master




func give_item(item: GameResource, receiver: Node2D):
	current_state.give_item(item, receiver)


func take_item(item: GameResource):
	current_state.take_item(item)


func operate():
	if current_state.operate():
		emit_signal("operated")
