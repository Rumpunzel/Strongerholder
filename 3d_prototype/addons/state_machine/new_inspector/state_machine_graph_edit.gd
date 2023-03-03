extends GraphEdit
tool

const CustomGraphNode := preload("res://addons/state_machine/new_inspector/graph_node.gd")
const StateGraphNode := preload("res://addons/state_machine/new_inspector/state_graph_node.gd")
const TransitionItemGraphNode := preload("res://addons/state_machine/new_inspector/transition_item_graph_node.gd")

const StateGraphNodeScene := preload("res://addons/state_machine/new_inspector/state_graph_node.tscn")
const TransitionItemGraphNodeScene := preload("res://addons/state_machine/new_inspector/transition_item_graph_node.tscn")
const BackToEntryPointGraphNodeScene := preload("res://addons/state_machine/new_inspector/back_to_entry_point_graph_node.tscn")

const _ENTRY_POINT := "EntryPoint"
const _ZOOM := "Zoom"

export var _size := Vector2(750.0, 250.0)

var transition_table: TransitionTable = null setget set_transition_table

var _entry_node: StateGraphNode = null
var _selected_node: CustomGraphNode = null
var _highlighting_enabled := false setget _set_highlighting_enabled


func _update_transitions(new_transitions: Array) -> void:
	print("Drawing Graph!")
	clear_connections()
	for child in get_children():
		if child is CustomGraphNode and not child == $EntryPoint:
			remove_child(child)
			child.queue_free()
	
	for i in new_transitions.size():
		var transition_item: TransitionItem = new_transitions[i]
		var offset: Vector2 = transition_table._graph_offsets.get(transition_item.resource_path, Vector2(0.0, i * _size.y) + _size * 0.5)
		_add_transition(transition_item, offset)
	
	_check_validity()

func _add_transition(transition_item_resource: TransitionItem, offset: Vector2) -> TransitionItemGraphNode:
	if not transition_table._transitions.has(transition_item_resource):
		transition_table._transitions.append(transition_item_resource)
	
	var new_transition_item_graph_node: TransitionItemGraphNode = TransitionItemGraphNodeScene.instance()
	add_child(new_transition_item_graph_node)
	move_child(new_transition_item_graph_node, 0)
	new_transition_item_graph_node.transition_item_resource = transition_item_resource
	new_transition_item_graph_node.offset = offset
	new_transition_item_graph_node.connect("changed", self, "_check_validity")
	new_transition_item_graph_node.connect("delete_requested", self, "_on_transition_item_delete_requested", [ new_transition_item_graph_node ])
	
	for from_state_resource in transition_item_resource.from_states:
		var from_state_offset: Vector2 = transition_table._graph_offsets.get(from_state_resource, offset + Vector2(-_size.x, _size.y) * 0.5)
		var from_state := _add_state(from_state_resource, from_state_offset)
		if from_state:
			connect_node(from_state.name, 0, new_transition_item_graph_node.name, 0)
	
	var to_state_resource: NodePath = transition_item_resource.to_state
	var to_state: CustomGraphNode
	if to_state_resource == transition_table.entry_state:
		var to_state_offset := offset + Vector2(_size.x * 0.6, _size.y * 0.25)
		to_state = _add_back_to_entry_point_node(to_state_offset)
	else:
		var to_state_offset: Vector2 = transition_table._graph_offsets.get(to_state_resource, offset + Vector2(_size.x, _size.y) * 0.5)
		to_state = _add_state(to_state_resource, to_state_offset)
	if to_state:
		connect_node(new_transition_item_graph_node.name, 0, to_state.name, 0)
	
	var condition_usages: Array = transition_item_resource.conditions
	if not condition_usages.empty():
		$Node/ConditionFileDialog.current_dir = condition_usages.front().condition.resource_path.get_base_dir()
	
	return new_transition_item_graph_node


func _add_state(state_resource: NodePath, offset: Vector2) -> StateGraphNode:
	if not state_resource:
		print("Tried to add State %s!" % state_resource)
		return null
	var existing_state := _has_state(state_resource)
	if existing_state:
		print("State <%s> is already in the graph!" % state_resource)
		return existing_state
	
	var new_state_graph_node: StateGraphNode = StateGraphNodeScene.instance()
	add_child(new_state_graph_node)
	move_child(new_state_graph_node, 0)
	new_state_graph_node.state_resource = state_resource
	new_state_graph_node.offset = offset
	new_state_graph_node.connect("delete_requested", self, "_on_state_delete_requested", [ new_state_graph_node ])
	
	return new_state_graph_node

func _add_back_to_entry_point_node(offset: Vector2) -> CustomGraphNode:
	var new_graph_node: CustomGraphNode = BackToEntryPointGraphNodeScene.instance()
	add_child(new_graph_node)
	move_child(new_graph_node, 0)
	new_graph_node.offset = offset
	new_graph_node.connect("close_request", self, "_on_jump_node_close_requested", [ new_graph_node ])
	
	new_graph_node.get_node("Label").text = transition_table.entry_state
	return new_graph_node


func _update_entry_node(state_graph_node: StateGraphNode) -> void:
	if state_graph_node == _entry_node:
		return
	
	var entry_point: CustomGraphNode = $EntryPoint
	if _entry_node:
		_disconnect_graph_node_outputs(entry_point.name)
		_entry_node.entry_status = false
	
	if state_graph_node and _check_state_node(state_graph_node):
		transition_table.entry_state = state_graph_node.state_resource
		state_graph_node.entry_status = true
	else:
		transition_table.entry_state_resource = null
	
	_entry_node = state_graph_node
	if _entry_node:
		connect_node(entry_point.name, 0, state_graph_node.name, 0)

func _cleanup() -> void:
	set_transition_table(transition_table)

func _check_validity() -> void:
	$EntryPoint.self_modulate = Color.coral if transition_table.entry_state else Color.crimson
	var problems: Array = transition_table.verify_table()
	for child in get_children():
		if child is StateGraphNode:
			_check_state_node(child)
		elif child is TransitionItemGraphNode:
			child.check_validity(problems)

func _check_state_node(state_node: StateGraphNode) -> bool:
	for connection in get_connection_list():
		if connection.from == state_node.name or (connection.to == state_node.name and not connection.from == _ENTRY_POINT):
			state_node.self_modulate = Color.cornflower
			return true
	state_node.self_modulate = Color.crimson
	return false

func _has_state(state_resouce: NodePath) -> StateGraphNode:
	for child in get_children():
		if child is StateGraphNode and child.state_resource == state_resouce:
			return child
	return null


func _connect_state_item_from(state_graph_node_name: String, to_transition_item_graph_node_name: String) -> void:
	var state_graph_node: StateGraphNode = get_node(state_graph_node_name)
	var transition_item_graph_node: TransitionItemGraphNode = get_node(to_transition_item_graph_node_name)
	var transition := transition_item_graph_node.transition_item_resource
	transition.from_states.append(state_graph_node.state_resource)
	connect_node(state_graph_node_name, 0, to_transition_item_graph_node_name, 0)
	if state_graph_node == _entry_node:
		_update_entry_node(_entry_node)

func _connect_state_item_to(state_graph_node_name: String, from_graph_node_name: String) -> void:
	var state_graph_node: StateGraphNode = get_node(state_graph_node_name)
	var node_to_connect_to: CustomGraphNode = get_node(from_graph_node_name)
	
	if node_to_connect_to is TransitionItemGraphNode:
		var transition: TransitionItem = node_to_connect_to.transition_item_resource
		transition.to_state = state_graph_node.state_resource
		_disconnect_graph_node_outputs(node_to_connect_to.name)
		connect_node(from_graph_node_name, 0, state_graph_node_name, 0)
	elif node_to_connect_to == $EntryPoint:
		_update_entry_node(state_graph_node)


func _disconnect_state_from(state_graph_node_name: String, to_transition_item_graph_node_name: String) -> void:
	var state_graph_node: StateGraphNode = get_node(state_graph_node_name)
	var transition_item_graph_node: TransitionItemGraphNode = get_node(to_transition_item_graph_node_name)
	var transition := transition_item_graph_node.transition_item_resource
	transition.from_states.erase(state_graph_node.state_resource)
	disconnect_node(state_graph_node_name, 0, to_transition_item_graph_node_name, 0)
	if state_graph_node == _entry_node:
		_update_entry_node(_entry_node)

func _disconnect_state_to(state_graph_node_name: String, from_graph_node_name: String) -> void:
	var node_to_disconnect_from: CustomGraphNode = get_node(from_graph_node_name)
	if node_to_disconnect_from is TransitionItemGraphNode:
		var transition: TransitionItem = node_to_disconnect_from.transition_item_resource
		transition.to_state = null
		disconnect_node(from_graph_node_name, 0, state_graph_node_name, 0)
	elif node_to_disconnect_from == $EntryPoint:
		_update_entry_node(null)


func _disconnect_graph_node(graph_node_name: String) -> void:
	_disconnect_graph_node_inputs(graph_node_name)
	_disconnect_graph_node_outputs(graph_node_name)

func _disconnect_graph_node_inputs(graph_node_name: String) -> void:
	for connection in get_connection_list():
		if connection.to == graph_node_name:
			disconnect_node(connection.from, 0, connection.to, 0)

func _disconnect_graph_node_outputs(graph_node_name: String) -> void:
	for connection in get_connection_list():
		if connection.from == graph_node_name:
			disconnect_node(connection.from, 0, connection.to, 0)


func set_transition_table(new_table: TransitionTable) -> void:
	transition_table = new_table
	
	_update_transitions(transition_table._transitions)
	if transition_table.entry_state:
		var entry_node := _has_state(transition_table.entry_state)
		_update_entry_node(entry_node)
	
	$EntryPoint.offset = transition_table._graph_offsets.get(_ENTRY_POINT, Vector2())
	$EntryPoint/Label.text = transition_table.resource_path.get_file().get_basename()
	zoom = transition_table._graph_offsets.get(_ZOOM, 1.0)
	_on_node_moved()


func _on_condition_files_selected(paths: PoolStringArray) -> void:
	var new_transition_item := TransitionItem.new()
	new_transition_item.from_states = [ ]
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
	_on_condition_files_selected([ path ])


func _on_connection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	var from_node: CustomGraphNode = get_node(from)
	var to_node: CustomGraphNode = get_node(to)
	if from_node is StateGraphNode:
		_connect_state_item_from(from, to)
	elif to_node is StateGraphNode:
		_connect_state_item_to(to, from)
	_check_validity()

func _on_disconnection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	var from_node: CustomGraphNode = get_node(from)
	var to_node: CustomGraphNode = get_node(to)
	
	if from_node is StateGraphNode:
		_disconnect_state_from(from, to)
	elif to_node is StateGraphNode:
		_disconnect_state_to(to, from)
	
	_check_validity()


func _on_state_delete_requested(state_graph_node: StateGraphNode) -> void:
	for connection in get_connection_list():
		if connection.from == state_graph_node.name:
			_disconnect_state_from(state_graph_node.name, connection.to)
		elif connection.to == state_graph_node.name:
			_disconnect_state_to(connection.from, state_graph_node.name)
	if state_graph_node.state_resource == transition_table.entry_state_resource:
		_update_entry_node(null)
	_check_validity()
	state_graph_node.disconnect("delete_requested", self, "_on_state_delete_requested")
	transition_table._graph_offsets.erase(state_graph_node.state_resource)
	remove_child(state_graph_node)
	state_graph_node.queue_free()

func _on_transition_item_delete_requested(transition_item_graph_node: TransitionItemGraphNode) -> void:
	_disconnect_graph_node(transition_item_graph_node.name)
	transition_table._transitions.erase(transition_item_graph_node.transition_item_resource)
	_check_validity()
	transition_item_graph_node.disconnect("changed", self, "_check_validity")
	transition_item_graph_node.disconnect("delete_requested", self, "_on_transition_item_delete_requested")
	transition_table._graph_offsets.erase(transition_item_graph_node.transition_item_resource.resource_path)
	remove_child(transition_item_graph_node)
	transition_item_graph_node.queue_free()

func _on_jump_node_close_requested(jump_node: CustomGraphNode) -> void:
	for connection in get_connection_list():
		if connection.to == jump_node.name:
			_disconnect_state_to(jump_node.name, connection.from)
			break
	_check_validity()
	jump_node.disconnect("close_request", self, "_on_jump_node_close_requested")
	remove_child(jump_node)
	jump_node.queue_free()


func _on_node_moved() -> void:
	transition_table._graph_offsets[_ZOOM] = zoom
	for child in get_children():
		if child == $EntryPoint:
			transition_table._graph_offsets[_ENTRY_POINT] = child.offset - scroll_offset
		elif child is StateGraphNode:
			transition_table._graph_offsets[child.state_resource] = child.offset - scroll_offset
		elif child is TransitionItemGraphNode:
			transition_table._graph_offsets[child.transition_item_resource.resource_path] = child.offset - scroll_offset


func _on_node_selected(graph_node: CustomGraphNode) -> void:
	_selected_node = graph_node
	if not _highlighting_enabled:
		return
	
	_change_highlighting_of_all_nodes(false)
	var connections := get_connection_list()
	var highlight_entry := graph_node.entry_node
	var highlight_exits := graph_node.entry_node
	
	for connection in connections:
		if connection.from == graph_node.name or connection.to == graph_node.name:
			var from_node: CustomGraphNode = get_node(connection.from)
			var to_node: CustomGraphNode = get_node(connection.to)
			from_node.highlighted = true
			to_node.highlighted = true
			
			if to_node.entry_node:
				highlight_entry = true
			if from_node.entry_node:
				highlight_exits = true
	
	if highlight_entry:
		_entry_node.highlighted = true
		$EntryPoint.highlighted = true
	for child in get_children():
		if highlight_exits and child is CustomGraphNode and child.entry_node:
			child.highlighted = true

func _on_node_unselected(graph_node: CustomGraphNode) -> void:
	if _selected_node == graph_node:
		_change_highlighting_of_all_nodes(true)

func _change_highlighting_of_all_nodes(new_status: bool) -> void:
	for child in get_children():
		if child is CustomGraphNode:
			child.highlighted = new_status

func _set_highlighting_enabled(new_status: bool) -> void:
	_highlighting_enabled = new_status
	if _highlighting_enabled:
		_on_node_selected(_selected_node)
	else:
		_on_node_unselected(_selected_node)

func _on_window_height_changed(value: float) -> void:
	rect_min_size.y = value
