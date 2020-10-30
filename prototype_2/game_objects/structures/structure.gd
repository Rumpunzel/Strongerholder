class_name Structure, "res://assets/icons/structures/icon_structure.svg"
extends GameObject


const PERSIST_PROPERTIES_2 := ["type"]
const PERSIST_OBJ_PROPERTIES_2 := ["_pilot_master"]


const _PILOT_MASTER_SCENE: PackedScene = preload("res://game_objects/structures/pilot_master.tscn")


export(Constants.Structures) var type: int

export(Array, PackedScene) var _starting_items


var _pilot_master: PilotMaster




func _ready():
	if _first_time:
		_first_time = false
		
		_initliase_pilot_master()
		_initliase_state_machine()
		
		_initliase_starting_items()
	
	
	add_to_group(Constants.enum_name(Constants.Structures, type))
	
	$audio_handler.connect_signals(_state_machine)


func _process(_delta: float):
	if _pilot_master and _state_machine:
		_pilot_master.process_commands(_state_machine)




func check_area_for_item(item: GameResource):
	_pilot_master.check_area_for_item(item)


func die():
	_pilot_master.drop_all_items()
	
	.die()



func _get_copy_of_collision_shape() -> CollisionShape2D:
	return $collision_shape.duplicate() as CollisionShape2D


func _get_copy_sprite() -> Sprite:
	return $sprite.duplicate() as Sprite



func _initliase_pilot_master():
	_pilot_master = _PILOT_MASTER_SCENE.instance()
	add_child(_pilot_master)


func _initliase_state_machine():
	_state_machine = StructureStateMachine.new()
	_state_machine.name = "state_machine"
	_state_machine._pilot_master = _pilot_master
	add_child(_state_machine)


func _initliase_starting_items():
	for item in _starting_items:
		var new_item: Node2D = item.instance()
		
		add_child(new_item)
		yield(get_tree(), "idle_frame")
		new_item.drop_item(global_position)
	
	_pilot_master.check_area_for_item()
