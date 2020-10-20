class_name Structure, "res://assets/icons/structures/icon_structure.svg"
extends GameObject


export(Constants.Structures) var type: int


onready var _pilot_master: PilotMaster = $pilot_master




func _ready():
	add_to_group(Constants.enum_name(Constants.Structures, type))


func _process(_delta: float):
	_pilot_master.process_commands(_state_machine)




func die():
	_pilot_master.drop_all_items()
	
	.die()
