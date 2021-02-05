class_name Structure, "res://class_icons/game_objects/structures/icon_structure.svg"
extends GameObject


const PERSIST_PROPERTIES_2 := ["starting_items"]
const PERSIST_OBJ_PROPERTIES_2 := ["_pilot_master"]


const PilotMasterScene: PackedScene = preload("res://game_objects/structures/pilot_master.tscn")


var starting_items: Dictionary = { }


var _pilot_master




func _ready() -> void:
	if _first_time:
		_first_time = false
		
		_initialise_pilot_master()
		_initialise_state_machine()
		
		_initialise_starting_items()
	
	$AudioHandler.connect_signals(_state_machine)


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



func _initialise_pilot_master() -> void:
	_pilot_master = PilotMasterScene.instance()
	_pilot_master.game_object = self
	add_child(_pilot_master)
	connect("died", _pilot_master, "unregister_resource")


func _initialise_state_machine() -> void:
	_state_machine = StructureStateMachine.new()
	_state_machine.name = "StateMachine"
	_state_machine.game_object = self
	_state_machine.pilot_master = _pilot_master
	_state_machine.hit_points_max = hit_points_max
	_state_machine.indestructible = indestructible
	
	add_child(_state_machine)


func _initialise_starting_items() -> void:
	for item in starting_items.keys():
		for _i in range(starting_items[item]):
			var new_item: Node2D = GameClasses.spawn_class_with_name(item)
			
			add_child(new_item)
			new_item.appear(false)
			_pilot_master.transfer_item(new_item)
