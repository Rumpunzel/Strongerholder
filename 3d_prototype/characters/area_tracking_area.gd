class_name AreaTrackingArea
extends Area

var areas_in_area := [ ]

func _enter_tree() -> void:
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func _on_area_entered(area: Area) -> void:
	areas_in_area.append(area)

func _on_area_exited(area: Area) -> void:
	areas_in_area.erase(area)
