class_name Spyglass, "res://assets/icons/icon_spyglass.svg"
extends GameResource


# warning-ignore-all:unused_class_variable
export(Array, Constants.Resources) var _used_for: Array


var used_for: Array = [ ]




# Called when the node enters the scene tree for the first time.
func _ready():
	used_for = _used_for.duplicate()
