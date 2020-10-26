class_name GameObject, "res://assets/icons/icon_game_object.svg"
extends StaticBody2D


signal died


export var _maximum_operators: int = 1


var _assigned_workers: Array = [ ]


onready var _collision_shape: CollisionShape2D = $collision_shape
onready var _state_machine: ObjectStateMachine = $state_machine



func assign_worker(puppet_master: Node2D):
	if not _assigned_workers.has(puppet_master):
		_assigned_workers.append(puppet_master)
	assert(_assigned_workers.size() <= _maximum_operators)


func unassign_worker(puppet_master: Node2D):
	_assigned_workers.erase(puppet_master)


func position_open() -> bool:
	return _assigned_workers.size() < _maximum_operators


func worker_assigned(puppet_master: Node2D) -> bool:
	return _assigned_workers.has(puppet_master) 



func damage(damage_points: float, sender) -> bool:
	return _state_machine.damage(damage_points, sender)


func die():
	emit_signal("died")



func is_active() -> bool:
	return _state_machine.is_active()


func enable_collision(new_status: bool):
	_collision_shape.set_deferred("disabled", not new_status)
