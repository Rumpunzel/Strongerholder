class_name HitBox, "res://editor_tools/class_icons/spatials/icon_heart_beats.svg"
extends Area

signal died()

export(Resource) var _vitals_resource

onready var _health: float = _vitals_resource.starting_health


func damage(value: float, _sender: Node) -> float:
	_health -= value
	_check_health()
	
	return value


func _check_health() -> void:
	if _health <= 0.0:
		_die()

func _die() -> void:
	emit_signal("died")
	owner.queue_free()
