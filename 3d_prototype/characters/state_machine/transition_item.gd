class_name TransitionItem, "res://addons/state_machine/icons/icon_fall_down.svg"
extends Resource

enum Operator { AND, OR }

# warning-ignore-all:unused_class_variable
export(Array, NodePath) var from_states = [ ] # [ StateNode ]
export(NodePath) var to_state = NodePath() # StateNode
export(Array, Resource) var conditions#: Array
export(Operator) var operator = Operator.AND#: int # Operator


func _to_string() -> String:
	return "(From States: %s, To State: %s, Conditions: %s, Operator: %s)" % [ from_states, to_state, conditions, operator ]
