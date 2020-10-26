class_name Structure, "res://assets/icons/structures/icon_structure.svg"
extends GameObject


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false
const SCENE := "res://game_objects/structures/Structure.tscn"

const PERSIST_PROPERTIES := ["name", "position", "_maximum_operators", "type"]
const PERSIST_OBJ_PROPERTIES := ["_assigned_workers"]


export(Constants.Structures) var type: int


onready var _pilot_master: PilotMaster = $pilot_master




func _ready():
	#yield(SaveHandler, "game_load_finished")
	
	add_to_group(Constants.enum_name(Constants.Structures, type))


func _process(_delta: float):
	_pilot_master.process_commands(_state_machine)




func check_area_for_item(item: GameResource):
	_pilot_master.check_area_for_item(item)


func die():
	_pilot_master.drop_all_items()
	
	.die()
