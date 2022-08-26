extends GraphEdit
tool

const StateGraphNode := preload("res://addons/state_machine/inspector/state_graph_node.gd")
const StateGraphNodeScene := preload("res://addons/state_machine/inspector/state_graph_node.tscn")
const TransitionItemGraphNode := preload("res://addons/state_machine/inspector/transition_item_graph_node.gd")
const TransitionItemGraphNodeScene := preload("res://addons/state_machine/inspector/transition_item_graph_node.tscn")

export var _x_size := 700.0
export var _y_size := 300.0

var transition_table: TransitionTableResource = null setget set_transition_table

var _state_graph_nodes := { } # StateResource -> StateGraphNode


func _add_transition(transition_item_resource: TransitionItemResource, x: int, y: int) -> TransitionItemGraphNode:
	var new_transition_item_graph_node: TransitionItemGraphNode = TransitionItemGraphNodeScene.instance()
	add_child(new_transition_item_graph_node)
	move_child(new_transition_item_graph_node, 0)
	new_transition_item_graph_node.transition_item_resource = transition_item_resource
	new_transition_item_graph_node.offset = Vector2(x + _x_size * 0.5, y + _y_size * 0.5)
	new_transition_item_graph_node.connect("delete_requested", self, "_on_transition_item_delete_requested", [ new_transition_item_graph_node ])
	
	var from_state := _add_state(transition_item_resource.from_state, x, y + _y_size * 0.5)
	var to_state := _add_state(transition_item_resource.to_state, x + _x_size, y + _y_size * 0.5)
	if from_state:
		connect_node(from_state.name, 0, new_transition_item_graph_node.name, 0)
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


func _add_state(state_resource: StateResource, x: float, y: float) -> StateGraphNode:
	if not state_resource:
		print("Tried to add State %s!" % state_resource)
		return null
	var existing_state: StateGraphNode = _state_graph_nodes.get(state_resource, null)
	if existing_state:
		print("State %s is already in the graph!" % state_resource.resource_path.get_file().get_basename().capitalize())
		return existing_state
	
	var new_state_graph_node: StateGraphNode = StateGraphNodeScene.instance()
	add_child(new_state_graph_node)
	move_child(new_state_graph_node, 0)
	new_state_graph_node.state_resource = state_resource
	new_state_graph_node.offset = Vector2(x, y)
	_state_graph_nodes[state_resource] = new_state_graph_node
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
	var new_state_node := _add_state(new_state, spawn_position.x, spawn_position.y)
	_check_state_node(new_state_node)


func _on_condition_files_selected(paths: PoolStringArray) -> void:
	for path in paths:
		_on_condition_file_selected(path)

func _on_condition_file_selected(path: String) -> void:
	var new_condition := load(path)
	if not (new_condition and new_condition is StateConditionResource):
		$Node/ConditionAcceptDialog.popup_centered()
		return
	
	var new_transition_item := TransitionItemResource.new()
	new_transition_item.from_state = null
	new_transition_item.to_state = null
	new_transition_item.conditions = [ ]
	var spawn_position := scroll_offset + rect_size * 0.5
	_add_transition(new_transition_item, spawn_position.x, spawn_position.y)


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


func set_transition_table(new_transition_table: TransitionTableResource) -> void:
	transition_table = new_transition_table
	for i in transition_table._transitions.size():
		_add_transition(transition_table._transitions[i], 0.0, i * _y_size)
	_check_validity()
