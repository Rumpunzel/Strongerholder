class_name HitBox, "res://editor_tools/class_icons/spatials/icon_heart_beats.svg"
extends Area

signal damaged()
signal died()

# warning-ignore:unused_class_variable
export(int, FLAGS, "Tree") var type := 0

export(Resource) var _vitals_resource

onready var _health: float = _vitals_resource.starting_health

var _called_dibs_by := [ ]


func _enter_tree() -> void:
	add_to_group(SavingAndLoading.PERSIST_DATA_GROUP)


func damage(value: float, sender: Node) -> float:
	_health -= value
	print("%s damaged %s by %1.1f" % [ sender.owner.name, owner.name, value ])
	emit_signal("damaged")
	_check_health()
	
	return value

func call_dibs(dibs: Node, dibbing: bool) -> void:
	if dibbing:
		if not _called_dibs_by.has(dibs):
			_called_dibs_by.append(dibs)
		assert(_called_dibs_by.size() <= _vitals_resource.maximum_attackers or _vitals_resource.maximum_attackers < 0)
	else:
		if _called_dibs_by.has(dibs):
			_called_dibs_by.erase(dibs)

func is_dibbable(dibs: Node) -> bool:
	return _called_dibs_by.has(dibs) or _called_dibs_by.size() < _vitals_resource.maximum_attackers or _vitals_resource.maximum_attackers < 0


func save_to_var(save_file: File) -> void:
	save_file.store_var(_health)

func load_from_var(save_file: File) -> void:
	_health = save_file.get_var()
	_check_health()


func _check_health() -> void:
	if _health <= 0.0:
		_die()

func _die() -> void:
	print("%s died" %  owner.name)
	emit_signal("died")
	owner.queue_free()
