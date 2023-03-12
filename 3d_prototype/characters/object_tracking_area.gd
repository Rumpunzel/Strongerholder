class_name ObjectTrackingArea
extends Area

var objects_in_area := [ ]

func _enter_tree() -> void:
	connect("area_entered", self, "_on_object_entered")
	connect("area_exited", self, "_on_object_exited")
	connect("body_entered", self, "_on_object_entered")
	connect("body_exited", self, "_on_object_exited")

func _on_object_entered(object: Node) -> void:
	objects_in_area.append(object)

func _on_object_exited(object: Node) -> void:
	objects_in_area.erase(object)
