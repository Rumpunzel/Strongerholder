extends GraphEdit
tool

const StateGraphNode := preload("res://addons/state_machine/inspector/state_graph_node.gd")
const StateGraphNodeScene := preload("res://addons/state_machine/inspector/state_graph_node.tscn")
const ConditionUsageGraphNode := preload("res://addons/state_machine/inspector/condition_usage_graph_node.gd")
const ConditionUsageGraphNodeScene := preload("res://addons/state_machine/inspector/condition_usage_graph_node.tscn")

const _x_size := 600.0
const _y_size := 300.0

var transition_table: TransitionTableResource = null setget set_transition_table

var _state_graph_nodes := { } # StateResource -> StateGraphNode



func _ready() -> void:
	rect_min_size = Vector2(400.0, 1000.0)
	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_EXPAND_FILL



func _add_transition(transition_item_resource: TransitionItemResource, index: int) -> void:
	var x := 0.0
	var y := index * _y_size
	
	var from_state := _add_state(transition_item_resource.from_state, x, y + _y_size * 0.5)
	var to_state := _add_state(transition_item_resource.to_state, _x_size, _y_size * 0.5)
	
	var conditions_count: int = transition_item_resource.conditions.size()
	for i in range(conditions_count):
		var x_offset := _x_size * 0.5
		var y_offset := 0.0 if i * 2 + 1 == conditions_count else (float(i) / float(conditions_count - 1)) * _y_size
		var condition := _add_condition(transition_item_resource.conditions[i], x + x_offset, y + y_offset)
		connect_node(from_state.name, 0, condition.name, 0)
		connect_node(condition.name, 0, to_state.name, 0)


func _add_state(state_resource: StateResource, x: float, y: float) -> StateGraphNode:
	var existing_state: StateGraphNode = _state_graph_nodes.get(state_resource, null)
	if existing_state:
		return existing_state
	
	var new_state_graph_node: StateGraphNode = StateGraphNodeScene.instance()
	add_child(new_state_graph_node)
	new_state_graph_node.state_resource = state_resource
	new_state_graph_node.offset = Vector2(x, y)
	_state_graph_nodes[state_resource] = new_state_graph_node
	
	return new_state_graph_node


func _add_condition(condition_usage_resource: ConditionUsageResource, x: float, y: float) -> ConditionUsageGraphNode:
	var new_condition_usage_graph_node: ConditionUsageGraphNode = ConditionUsageGraphNodeScene.instance()
	add_child(new_condition_usage_graph_node)
	new_condition_usage_graph_node.condition_usage_resource = condition_usage_resource
	new_condition_usage_graph_node.offset = Vector2(x, y)
	
	return new_condition_usage_graph_node


func set_transition_table(new_transition_table: TransitionTableResource) -> void:
	transition_table = new_transition_table
	for i in transition_table._transitions.size():
		_add_transition(transition_table._transitions[i], i)
