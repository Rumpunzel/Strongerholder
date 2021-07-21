class_name ToolResource, "res://editor_tools/class_icons/resources/icon_thor_hammer.svg"
extends ItemResource

# warning-ignore-all:unused_class_variable
export(int, FLAGS, "Tree") var used_on := 0
export var damage: float = 1.0

func _to_string() -> String:
	return "%s, Used On: %s, Damage: %d" % [ ._to_string(), used_on, damage ]
