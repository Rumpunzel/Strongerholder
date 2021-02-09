class_name CityStructureState
extends StructureState


signal operated



func operate() -> void:
	emit_signal("operated")
