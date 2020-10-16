class_name GameObject, "res://assets/icons/icon_game_object.svg"
extends StaticBody2D


signal died


onready var _collision_shape: CollisionShape2D = $collision_shape
onready var _state_machine: StateMachine = $state_machine




func damage(damage_points: float, sender) -> bool:
	return _state_machine.damage(damage_points, sender)


func die():
	emit_signal("died")



func is_active() -> bool:
	return _state_machine.is_active()
