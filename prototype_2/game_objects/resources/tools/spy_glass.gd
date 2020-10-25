class_name Spyglass, "res://assets/icons/icon_spyglass.svg"
extends GameResource


const SCENE_OVERRIDE := "res://game_objects/resources/tools/Spyglass.tscn"

const PERSIST_PROPERTIES_3 := ["gathers", "delivers"]


# warning-ignore-all:unused_class_variable
export(Array, Constants.Resources) var gathers: Array
# warning-ignore-all:unused_class_variable
export(Array, Constants.Resources) var delivers: Array
