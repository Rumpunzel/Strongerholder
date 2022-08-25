extends GraphEdit
tool

const StateGraphNode := preload("res://addons/state_machine/inspector/state_graph_node.gd")
const ConditionUsageGraphNode := preload("res://addons/state_machine/inspector/condition_usage_graph_node.gd")

const _x_size := 800.0
const _y_size := 400.0

var _transitions := [ ]


func add_transition(transition_item_resource: TransitionItemResource) -> void:
	var x := 0.0
	var y := _transitions.size() * _y_size
	_transitions.append(transition_item_resource)
	
	var from_state := _add_state(transition_item_resource.from_state, x, y + _y_size * 0.5)
	var to_state := _add_state(transition_item_resource.to_state, _x_size, _y_size * 0.5)
	
	var conditions := _add_conditions(transition_item_resource.conditions)
	for i in conditions.size():
		var condition: ConditionUsageGraphNode = conditions[i]
		connect_node(from_state.name, 0, condition.name, 0)
		connect_node(condition.name, 0, to_state.name, 0)
		var y_offset := 0.0 if i * 2 + 1 == conditions.size() else (float(i) / float(conditions.size() - 1)) * _y_size
		condition.offset = Vector2(_x_size * 0.5, y + y_offset)



func _add_state(state_resource: StateResource, x: float, y: float) -> StateGraphNode:
	var existing_state := _has_state(state_resource)
	if existing_state:
		return existing_state
	
	var new_state_graph_node := StateGraphNode.new(state_resource)
	add_child(new_state_graph_node)
	new_state_graph_node.offset = Vector2(x, y)
	return new_state_graph_node

func _has_state(state_resource: StateResource) -> StateGraphNode:
	for resource in _transitions:
		var transition: TransitionItemResource = resource
		if transition.from_state == state_resource or transition.to_state == state_resource:
			for child in get_children():
				if not child is StateGraphNode:
					continue
				var state_graph_node: StateGraphNode = child
				if state_graph_node.state_resource == state_resource:
					return state_graph_node
	return null


func _add_conditions(conditions: Array) -> Array:
	var graph_nodes := [ ]
	
	for resource in conditions:
		var condition_usage_resource: ConditionUsageResource = resource
		var new_condition_usage_graph_node := ConditionUsageGraphNode.new(condition_usage_resource)
		add_child(new_condition_usage_graph_node)
		graph_nodes.append(new_condition_usage_graph_node)
		
	return graph_nodes
