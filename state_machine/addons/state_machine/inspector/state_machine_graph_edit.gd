extends GraphEdit
tool

const StateGraphNode := preload("res://addons/state_machine/inspector/state_graph_node.gd")
const StateGraphNodeScene := preload("res://addons/state_machine/inspector/state_graph_node.tscn")
const TransitionItemGraphNode := preload("res://addons/state_machine/inspector/transition_item_graph_node.gd")
const TransitionItemGraphNodeScene := preload("res://addons/state_machine/inspector/transition_item_graph_node.tscn")

export var _x_size := 700.0
export var _y_size := 300.0

var transition_table: TransitionTableResource = null setget set_transition_table



func _add_transition(transition_item_resource: TransitionItemResource, offset: Vector2) -> TransitionItemGraphNode:
	if not transition_table._transitions.has(transition_item_resource):
		transition_table._transitions.append(transition_item_resource)
	
	var new_transition_item_graph_node: TransitionItemGraphNode = TransitionItemGraphNodeScene.instance()
	add_child(new_transition_item_graph_node)
	move_child(new_transition_item_graph_node, 0)
	new_transition_item_graph_node.transition_item_resource = transition_item_resource
	new_transition_item_graph_node.offset = offset + Vector2(_x_size, _y_size) * 0.5
	new_transition_item_graph_node.connect("delete_requested", self, "_on_transition_item_delete_requested", [ new_transition_item_graph_node ])
	
	var from_state_resource: StateResource = transition_item_resource.from_state
	var from_state := _add_state(from_state_resource, offset + Vector2(0.0, _y_size * 0.5))
	if from_state:
		connect_node(from_state.name, 0, new_transition_item_graph_node.name, 0)
	
	var to_state_resource: StateResource = transition_item_resource.to_state
	var to_state := _add_state(to_state_resource, offset + Vector2(_x_size, _y_size * 0.5))
	if to_state:
		connect_node(new_transition_item_graph_node.name, 0, to_state.name, 0)
	
	var condition_usages: Array = transition_item_resource.conditions
	if not condition_usages.empty():
		$Node/ConditionFileDialog.current_dir = condition_usages.front().condition.resource_path.get_base_dir()
	
	return new_transition_item_graph_node


func _check_validity() -> void:
	for child in get_children():
		if child is StateGraphNode:
			_check_state_node(child)
		elif child is TransitionItemGraphNode:
			child.check_validity()

func _check_state_node(state_node: StateGraphNode) -> void:
	for connection in get_connection_list():
		if connection.from == state_node.name or connection.to == state_node.name:
			state_node.self_modulate = Color.white
			return
	state_node.self_modulate = Color.crimson


func _add_state(state_resource: StateResource, offset: Vector2) -> StateGraphNode:
	if not state_resource:
		print("Tried to add State %s!" % state_resource)
		return null
	var existing_state := _has_state(state_resource)
	if existing_state:
		print("State <%s> is already in the graph!" % state_resource.resource_path.get_file().get_basename().capitalize())
		return existing_state
	
	var new_state_graph_node: StateGraphNode = StateGraphNodeScene.instance()
	add_child(new_state_graph_node)
	move_child(new_state_graph_node, 0)
	new_state_graph_node.state_resource = state_resource
	new_state_graph_node.offset = offset
	new_state_graph_node.connect("delete_requested", self, "_on_state_delete_requested", [ new_state_graph_node ])
	$Node/StateFileDialog.current_dir = state_resource.resource_path.get_base_dir()
	
	return new_state_graph_node


func _connect_state_item_from(state_graph_node_name: String, to_transition_item_graph_node_name: String) -> void:
	var state_graph_node: StateGraphNode = get_node(state_graph_node_name)
	var transition_item_graph_node: TransitionItemGraphNode = get_node(to_transition_item_graph_node_name)
	var transition := transition_item_graph_node.transition_item_resource
	
	_disconnect_transition_item_inputs(transition_item_graph_node)
	transition.from_state = state_graph_node.state_resource
	connect_node(state_graph_node_name, 0, to_transition_item_graph_node_name, 0)

func _connect_state_item_to(state_graph_node_name: String, from_transition_item_graph_node_name: String) -> void:
	var state_graph_node: StateGraphNode = get_node(state_graph_node_name)
	var transition_item_graph_node: TransitionItemGraphNode = get_node(from_transition_item_graph_node_name)
	var transition := transition_item_graph_node.transition_item_resource
	
	_disconnect_transition_item_outputs(transition_item_graph_node)
	transition.to_state = state_graph_node.state_resource
	connect_node(from_transition_item_graph_node_name, 0, state_graph_node_name, 0)


func _disconnect_state_from(state_graph_node_name: String, to_transition_item_graph_node_name: String) -> void:
	var transition_item_graph_node: TransitionItemGraphNode = get_node(to_transition_item_graph_node_name)
	var transition := transition_item_graph_node.transition_item_resource
	
	transition.from_state = null
	disconnect_node(state_graph_node_name, 0, to_transition_item_graph_node_name, 0)

func _disconnect_state_to(state_graph_node_name: String, from_transition_item_graph_node_name: String) -> void:
	var transition_item_graph_node: TransitionItemGraphNode = get_node(from_transition_item_graph_node_name)
	var transition := transition_item_graph_node.transition_item_resource
	
	transition.to_state = null
	disconnect_node(from_transition_item_graph_node_name, 0, state_graph_node_name, 0)


func _disconnect_transition_item(transition_item_graph_node: TransitionItemGraphNode) -> void:
	_disconnect_transition_item_inputs(transition_item_graph_node)
	_disconnect_transition_item_outputs(transition_item_graph_node)

func _disconnect_transition_item_inputs(transition_item_graph_node: TransitionItemGraphNode) -> void:
	for connection in get_connection_list():
		if connection.to == transition_item_graph_node.name:
			disconnect_node(connection.from, 0, connection.to, 0)

func _disconnect_transition_item_outputs(transition_item_graph_node: TransitionItemGraphNode) -> void:
	for connection in get_connection_list():
		if connection.from == transition_item_graph_node.name:
			disconnect_node(connection.from, 0, connection.to, 0)


func _has_state(state_resouce: StateResource) -> StateGraphNode:
	for child in get_children():
		if child is StateGraphNode and child.state_resource == state_resouce:
			return child
	return null


func _on_state_delete_requested(state_graph_node: StateGraphNode) -> void:
	for connection in get_connection_list():
		if connection.from == state_graph_node.name:
			_disconnect_state_from(state_graph_node.name, connection.to)
		elif connection.to == state_graph_node.name:
			_disconnect_state_to(connection.from, state_graph_node.name)
	_check_validity()
	state_graph_node.disconnect("delete_requested", self, "_on_state_delete_requested")
	remove_child(state_graph_node)
	state_graph_node.queue_free()

func _on_transition_item_delete_requested(transition_item_graph_node: TransitionItemGraphNode) -> void:
	_disconnect_transition_item(transition_item_graph_node)
	transition_table._transitions.erase(transition_item_graph_node.transition_item_resource)
	_check_validity()
	transition_item_graph_node.disconnect("delete_requested", self, "_on_transition_item_delete_requested")
	remove_child(transition_item_graph_node)
	transition_item_graph_node.queue_free()


func _on_state_files_selected(paths: PoolStringArray) -> void:
	for path in paths:
		_on_state_file_selected(path)

func _on_state_file_selected(path: String) -> void:
	var new_state := load(path)
	if not (new_state and new_state is StateResource):
		$Node/StateAcceptDialog.popup_centered()
		return
		
	var spawn_position := scroll_offset + rect_size * 0.5
	var new_state_node := _add_state(new_state, spawn_position)
	_check_state_node(new_state_node)


func _on_condition_files_selected(paths: PoolStringArray) -> void:
	var new_transition_item := TransitionItemResource.new()
	new_transition_item.from_state = null
	new_transition_item.to_state = null
	
	var new_condition_usages := [ ]
	for path in paths:
		var new_condition := load(path)
		if not (new_condition and new_condition is StateConditionResource):
			$Node/ConditionAcceptDialog.popup_centered()
			return
		
		var new_condition_usage := ConditionUsageResource.new()
		new_condition_usage.condition = new_condition
		new_condition_usages.append(new_condition_usage)
	
	new_transition_item.conditions = new_condition_usages
	var spawn_position := scroll_offset + rect_size * 0.5
	_add_transition(new_transition_item, spawn_position)

func _on_condition_file_selected(path: String) -> void:
	var new_condition := load(path)
	if not (new_condition and new_condition is StateConditionResource):
		$Node/ConditionAcceptDialog.popup_centered()
		return
	
	var new_transition_item := TransitionItemResource.new()
	var new_condition_usage := ConditionUsageResource.new()
	new_transition_item.from_state = null
	new_transition_item.to_state = null
	new_condition_usage.condition = new_condition
	new_transition_item.conditions = [ new_condition_usage ]
	var spawn_position := scroll_offset + rect_size * 0.5
	_add_transition(new_transition_item, spawn_position)


func _on_connection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	var from_node: GraphNode = get_node(from)
	var to_node: GraphNode = get_node(to)
	if from_node is StateGraphNode:
		_connect_state_item_from(from, to)
	elif to_node is StateGraphNode:
		_connect_state_item_to(to, from)
	_check_validity()

func _on_disconnection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	var from_node: GraphNode = get_node(from)
	var to_node: GraphNode = get_node(to)
	if from_node is StateGraphNode:
		_disconnect_state_from(from, to)
	elif to_node is StateGraphNode:
		_disconnect_state_to(to, from)
	_check_validity()


func _on_node_moved() -> void:
	transition_table._transitions.sort_custom(self, "_sort_grap_nodes_by_y")


func set_transition_table(new_transition_table: TransitionTableResource) -> void:
	transition_table = new_transition_table
	for i in transition_table._transitions.size():
		var transition_item: TransitionItemResource = transition_table._transitions[i]
		_add_transition(transition_item, Vector2(0.0, i * _y_size))
	
	_check_validity()


func _sort_grap_nodes_by_y(resource_a: Resource, resource_b: Resource) -> bool:
	var graph_node_a := _graph_node_for_resource(resource_a)
	var graph_node_b := _graph_node_for_resource(resource_b)
	
	if graph_node_a.offset.y < graph_node_b.offset.y:
		return true
	elif graph_node_a.offset.y == graph_node_b.offset.y:
		return graph_node_a.offset.x <= graph_node_b.offset.x
	else:
		return false

func _graph_node_for_resource(resource: Resource) -> GraphNode:
	for child in get_children():
		if child is StateGraphNode and child.state_resource == resource:
			return child
		elif child is TransitionItemGraphNode and child.transition_item_resource == resource:
			return child
	return null
