class_name ExplorationArea, "res://editor_tools/class_icons/spatials/icon_treasure_map.svg"
extends Area

onready var _ray_cast: RayCast = $RayCast
onready var _character: Spatial = owner
# warning-ignore:unsafe_method_access
onready var _spotted_items: SpottedItems = _character.get_navigation().spotted_items


func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("body_exited", self, "_on_node_sighting")

func _exit_tree() -> void:
	disconnect("body_exited", _spotted_items, "_on_item_spotted")


func _on_node_sighting(object: Node) -> void:
	# TODO: Implement RayCasint
	_spotted_items._on_item_spotted(object, self)
