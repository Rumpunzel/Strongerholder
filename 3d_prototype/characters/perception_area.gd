class_name PerceptionArea, "res://editor_tools/class_icons/spatials/icon_semi_closed_eye.svg"
extends ObjectTrackingArea

onready var _character: Spatial = owner
# warning-ignore:unsafe_method_access
onready var _spotted_items: SpottedItems = _character.get_navigation().spotted_items

func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("body_entered", _spotted_items, "_on_item_approached", [ self ])
	# warning-ignore:return_value_discarded
	connect("body_exited", _spotted_items, "_on_item_spotted", [ self ])

func _exit_tree() -> void:
	disconnect("body_entered", _spotted_items, "_on_item_approached")
	disconnect("body_exited", _spotted_items, "_on_item_spotted")
