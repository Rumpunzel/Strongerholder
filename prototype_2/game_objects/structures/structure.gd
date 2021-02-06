class_name Structure, "res://class_icons/game_objects/structures/icon_structure.svg"
extends GameObject


const SCENE := "res://game_objects/structures/structure.tscn"

const PERSIST_PROPERTIES_2 := ["starting_items"]
const PERSIST_OBJ_PROPERTIES_2 := ["_pilot_master"]


var starting_items: Dictionary = { }

var _pilot_master: PilotMaster


onready var _audio_handler: AudioHandler = $AudioHandler




func _ready() -> void:
	if _first_time:
		_first_time = false
		
		_initialisation()
	
	connect("damaged", _audio_handler, "play_damage_audio")


func _process(_delta: float) -> void:
	if _pilot_master and _state_machine:
		_pilot_master.process_commands(_state_machine)




func transfer_item(item: Node2D) -> void:
	_pilot_master.transfer_item(item)


func die() -> void:
	_pilot_master.drop_all_items()
	
	.die()



func _get_copy_of_collision_shape() -> CollisionShape2D:
	return $CollisionShape.duplicate() as CollisionShape2D


func _get_copy_sprite() -> Sprite:
	return $Sprite.duplicate() as Sprite



func _initialisation() -> void:
	_initialise_pilot_master()
	
	._initialisation()
	
	_initialise_starting_items()


func _initialise_pilot_master(new_pilot_master := load("res://game_objects/structures/components/pilot_master.tscn")) -> void:
	_pilot_master = new_pilot_master.instance()
	_pilot_master.game_object = self
	
	add_child(_pilot_master)
	
	connect("died", _pilot_master, "unregister_resource")


func _initialise_state_machine(new_state_machine: ObjectStateMachine = StructureStateMachine.new()) -> void:
	._initialise_state_machine(new_state_machine)
	
	_state_machine.connect("operated", _pilot_master, "refine_resource")
	_state_machine.connect("item_dropped", _pilot_master, "drop_item")
	_state_machine.connect("took_item", _pilot_master, "pick_up_item")


func _initialise_starting_items() -> void:
	for item in starting_items.keys():
		for _i in range(starting_items[item]):
			var new_item: Node2D = GameClasses.spawn_class_with_name(item)
			_pilot_master.recieve_transferred_item(new_item)
