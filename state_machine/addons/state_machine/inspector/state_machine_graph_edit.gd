extends GraphEdit
tool

const StateGraphNode := preload("res://addons/state_machine/inspector/state_graph_node.gd")
const StateGraphNodeScene := preload("res://addons/state_machine/inspector/state_graph_node.tscn")
const ConditionUsageGraphNode := preload("res://addons/state_machine/inspector/condition_usage_graph_node.gd")
const ConditionUsageGraphNodeScene := preload("res://addons/state_machine/inspector/condition_usage_graph_node.tscn")

export var _x_size := 600.0
export var _y_size := 300.0

var transition_table: TransitionTableResource = null setget set_transition_table

var _state_graph_nodes := { } # StateResource -> StateGraphNode



func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index == BUTTON_RIGHT and not mouse_event.pressed:
			var context_menu: PopupMenu = $Node/ContextMenu
			context_menu.popup()
			context_menu.rect_global_position = get_global_mouse_position()



func _add_transition(transition_item_resource: TransitionItemResource, index: int) -> void:
	var x := 0.0
	var y := index * _y_size
	
	var from_state := _add_state(transition_item_resource.from_state, x, y + _y_size * 0.5)
	var to_state := _add_state(transition_item_resource.to_state, _x_size, _y_size * 0.5)
	
	var conditions_count: int = transition_item_resource.conditions.size()
	for i in range(conditions_count):
		var x_offset := _x_size * 0.5
		var y_offset := _y_size * 0.5 if i * 2 + 1 == conditions_count else (float(i) / float(conditions_count - 1)) * _y_size
		var condition := _add_condition(transition_item_resource.conditions[i], x + x_offset, y + y_offset)
		connect_node(from_state.name, 0, condition.name, 0)
		connect_node(condition.name, 0, to_state.name, 0)


func _add_state(state_resource: StateResource, x: float, y: float) -> StateGraphNode:
	var existing_state: StateGraphNode = _state_graph_nodes.get(state_resource, null)
	if existing_state:
		print("State %s is already in the graph!" % state_resource.resource_path.get_file().get_basename().capitalize())
		return existing_state
	
	var new_state_graph_node: StateGraphNode = StateGraphNodeScene.instance()
	add_child(new_state_graph_node)
	new_state_graph_node.state_resource = state_resource
	new_state_graph_node.offset = Vector2(x, y)
	_state_graph_nodes[state_resource] = new_state_graph_node
	new_state_graph_node.connect("delete_requested", self, "_on_state_delete_requested", [ new_state_graph_node ])
	$Node/StateFileDialog.current_dir = state_resource.resource_path.get_base_dir()
	
	return new_state_graph_node


func _add_condition(condition_usage_resource: ConditionUsageResource, x: float, y: float) -> ConditionUsageGraphNode:
	var new_condition_usage_graph_node: ConditionUsageGraphNode = ConditionUsageGraphNodeScene.instance()
	add_child(new_condition_usage_graph_node)
	new_condition_usage_graph_node.condition_usage_resource = condition_usage_resource
	new_condition_usage_graph_node.offset = Vector2(x, y)
	new_condition_usage_graph_node.connect("delete_requested", self, "_on_condition_usage_delete_requested", [ new_condition_usage_graph_node ])
	$Node/ConditionFileDialog.current_dir = condition_usage_resource.condition.resource_path.get_base_dir()
	
	return new_condition_usage_graph_node


func set_transition_table(new_transition_table: TransitionTableResource) -> void:
	transition_table = new_transition_table
	for i in transition_table._transitions.size():
		_add_transition(transition_table._transitions[i], i)


func _on_state_delete_requested(state_graph_node: StateGraphNode) -> void:
	for connection in get_connection_list():
		if connection.from == state_graph_node.name:
			for resource in transition_table._transitions:
				var transtion: TransitionItemResource = resource
				if transtion.from_state == state_graph_node.state_resource:
					transtion.from_state = null
			disconnect_node(connection.from, 0, connection.to, 0)
		elif connection.to == state_graph_node.name:
			for resource in transition_table._transitions:
				var transtion: TransitionItemResource = resource
				if transtion.to_state == state_graph_node.state_resource:
					transtion.to_state = null
			disconnect_node(connection.from, 0, connection.to, 0)
	
	state_graph_node.disconnect("delete_requested", self, "_on_state_delete_requested")
	remove_child(state_graph_node)
	state_graph_node.queue_free()

func _on_condition_usage_delete_requested(condition_usage_graph_node: ConditionUsageGraphNode) -> void:
	for connection in get_connection_list():
		if connection.from == condition_usage_graph_node.name or connection.to == condition_usage_graph_node.name:
			for resource in transition_table._transitions:
				var transtion: TransitionItemResource = resource
				if transtion.conditions.has(condition_usage_graph_node.condition_usage_resource):
					transtion.conditions.erase(condition_usage_graph_node.condition_usage_resource)
			disconnect_node(connection.from, 0, connection.to, 0)
	
	condition_usage_graph_node.disconnect("delete_requested", self, "_on_condition_usage_delete_requested")
	remove_child(condition_usage_graph_node)
	condition_usage_graph_node.queue_free()


func _on_state_file_selected(path: String) -> void:
	var new_state := load(path)
	if not (new_state and new_state is StateResource):
		$Node/StateAcceptDialog.popup_centered()
		return
	
	var mouse_position := get_global_mouse_position()
	_add_state(new_state, mouse_position.x, mouse_position.y)

func _on_condition_file_selected(path: String) -> void:
	var new_condition := load(path)
	if not (new_condition and new_condition is StateConditionResource):
		$Node/ConditionAcceptDialog.popup_centered()
		return
	
	var mouse_position := get_local_mouse_position()
	var new_condition_usage := ConditionUsageResource.new()
	new_condition_usage.condition = new_condition
	_add_condition(new_condition_usage, mouse_position.x, mouse_position.y)
