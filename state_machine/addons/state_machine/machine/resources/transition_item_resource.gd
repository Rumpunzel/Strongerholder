class_name TransitionItemResource, "res://addons/state_machine/icons/icon_plain_arrow.svg"
extends Resource

enum Operator { AND, OR }

# warning-ignore-all:unused_class_variable
export(Resource) var from_state#: StateResource
export(Resource) var to_state#: StateResource
export(Array, Resource) var conditions#: Array
export(Operator) var operator = Operator.AND#: int # Operator


func _to_string() -> String:
	return "(From State: %s, To State: %s, Conditions: %s, Operator: %s)" % [ from_state, to_state, conditions, operator ]
