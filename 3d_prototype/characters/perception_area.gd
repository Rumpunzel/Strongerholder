class_name PerceptionArea, "res://editor_tools/class_icons/spatials/icon_semi_closed_eye.svg"
extends Area

signal object_entered_perception_area(object)
signal object_exited_perception_area(object)

var objects_in_perception_range := [ ]

onready var _character: Spatial = owner
# warning-ignore:unsafe_method_access
onready var _spotted_items: SpottedItems = _character.get_navigation().spotted_items


func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("object_exited_perception_area", _spotted_items, "_on_item_spotted", [ self ])
	# warning-ignore:return_value_discarded
	connect("object_entered_perception_area", _spotted_items, "_on_item_approached", [ self ])

func _exit_tree() -> void:
	disconnect("object_exited_perception_area", _spotted_items, "_on_item_spotted")
	disconnect("object_entered_perception_area", _spotted_items, "_on_item_approached")


func _on_object_entered_perception_area(object: Node) -> void:
	objects_in_perception_range.append(object)
	emit_signal("object_entered_perception_area", object)

func _on_object_exited_perception_area(object: Node) -> void:
	objects_in_perception_range.erase(object)
	emit_signal("object_exited_perception_area", object)
