extends GraphEdit
tool

const StateGraphNode := preload("res://addons/state_machine/inspector/state_graph_node.gd")

var _transitions := [ ]


func add_transition(transition_item_resource: TransitionItemResource) -> void:
	_transitions.append(transition_item_resource)
	var from_state := _add_state(transition_item_resource.from_state)
	var to_state := _add_state(transition_item_resource.to_state)
	connect_node(from_state.name, 0, to_state.name, 0)


func _add_state(state_resource: StateResource) -> StateGraphNode:
	var existing_state := _has_state(state_resource)
	if existing_state:
		return existing_state
	
	var new_state_graph_node := StateGraphNode.new(state_resource)
	add_child(new_state_graph_node)
	var node_count := get_child_count() - 3
	new_state_graph_node.rect_position = Vector2((node_count % 4) * 200.0, int(node_count / 4) * 200.0)
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
