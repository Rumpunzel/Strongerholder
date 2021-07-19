class_name HitBox, "res://editor_tools/class_icons/spatials/icon_heart_beats.svg"
extends Area

signal damaged()
signal died()

export(Resource) var _vitals_resource

onready var _health: float = _vitals_resource.starting_health


func damage(value: float, sender: Node) -> float:
	_health -= value
	print("%s damaged %s by %1.1f" % [ sender.owner.name, owner.name, value ])
	emit_signal("damaged")
	_check_health()
	
	return value


func _check_health() -> void:
	if _health <= 0.0:
		_die()

func _die() -> void:
	print("%s died" %  owner.name)
	emit_signal("died")
	owner.queue_free()
