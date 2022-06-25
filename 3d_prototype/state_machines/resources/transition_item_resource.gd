class_name TransitionItemResource, "res://editor_tools/class_icons/resources/icon_plain_arrow.svg"
extends Resource

# warning-ignore-all:unused_class_variable
export(Resource) var from_state#: StateResource
export(Resource) var to_state#: StateResource
export(Array, Resource) var conditions#: Array


func _to_string() -> String:
	return "(From State: %s, To State: %s, Conditions: %s)" % [ from_state, to_state, conditions ]
