class_name Stash, "res://editor_tools/class_icons/spatials/icon_wooden_crate.svg"
extends Area

onready var _inventory: Inventory = Utils.find_node_of_type_in_children(owner, Inventory)
