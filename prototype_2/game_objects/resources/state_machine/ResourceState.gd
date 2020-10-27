class_name ResourceState, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name"]
const PERSIST_OBJ_PROPERTIES := ["_state_machine", "_game_object"]


const IDLE = "idle"
const INACTIVE = "inactive"
const DEAD = "dead"


var _state_machine = null
# warning-ignore-all:unused_class_variable
var _game_object = null



func _ready():
	if not _state_machine:
		_state_machine = get_parent()
	
	if not _game_object:
		_game_object = owner



func enter(_parameters: Array = [ ]):
	pass


func exit(next_state: String, parameters: Array = [ ]):
	_state_machine._change_to(next_state, parameters)



func damage(damage_points: float, _sender) -> float:
	return damage_points



func drop_item(objects_layer: YSort, position_to_drop: Vector2):
	_game_object.get_parent().remove_child(_game_object)
	objects_layer.call_deferred("add_child", _game_object)
	
	_game_object.global_position = position_to_drop
	
	exit(IDLE)


func pick_up_item(new_inventory: Inventory):
	exit(INACTIVE)
	
	_game_object.position = Vector2()
	_game_object.get_parent().remove_child(_game_object)
	new_inventory.call_deferred("_add_item", _game_object)



func is_active() -> bool:
	return true



func _toggle_active_state(object: Node, new_state: bool):
	object.appear(new_state)
	object.enable_collision(new_state)
	
	object.set_process(new_state)
	object.set_physics_process(new_state)
