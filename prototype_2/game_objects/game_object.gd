class_name GameObject
extends StaticBody2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name", "position", "maximum_operators", "_first_time"]
const PERSIST_OBJ_PROPERTIES := ["_assigned_workers", "_state_machine"]


signal died


export var maximum_operators: int = 1


var selected: bool = false setget set_selected


# warning-ignore-all:unused_class_variable
var _first_time: bool = true
var _state_machine

var _assigned_workers: Array = [ ]


onready var _collision_shape: CollisionShape2D = $CollisionShape
onready var _selection_outline: SelectionOutline = $SelectionOutline




func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("select_object"):
		get_tree().set_input_as_handled()
		set_selected(true)

# TODO: kind of a hack to get deselecting to work atm
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select_object"):
		set_selected(false)




func assign_worker(puppet_master: Node2D) -> void:
	if not _assigned_workers.has(puppet_master):
		_assigned_workers.append(puppet_master)
	assert(_assigned_workers.size() <= maximum_operators)


func unassign_worker(puppet_master: Node2D) -> void:
	_assigned_workers.erase(puppet_master)


func position_open(puppet_master: Node2D) -> bool:
	return worker_assigned(puppet_master) or _assigned_workers.size() < maximum_operators


func worker_assigned(puppet_master: Node2D) -> bool:
	return _assigned_workers.has(puppet_master) 



func damage(damage_points: float, sender) -> bool:
	return _state_machine.damage(damage_points, sender)


func die() -> void:
	emit_signal("died")



func is_active() -> bool:
	return _state_machine.is_active()


func enable_collision(new_status: bool) -> void:
	_collision_shape.set_deferred("disabled", not new_status)



func set_selected(new_status: bool) -> void:
	selected = new_status
	_selection_outline.visible = selected
