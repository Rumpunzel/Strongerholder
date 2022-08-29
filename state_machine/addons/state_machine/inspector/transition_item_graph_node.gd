extends GraphNode
tool

signal delete_requested()

enum MenuButtons {
	MOVE_UP,
	MOVE_DOWN,
	DELETE,
}

const ConditionUsage := preload("res://addons/state_machine/inspector/condition_usage.gd")
const ConditionUsageScene := preload("res://addons/state_machine/inspector/condition_usage.tscn")

const _MENU_BUTTON_NAME := "MenuButton"

var transition_item_resource: TransitionItemResource setget set_transition_item_resource


func check_validity() -> void:
	_update_style()


func _update_style() -> void:
	rect_size = Vector2()
	var has_to_state: bool = transition_item_resource.to_state != null
	
	var from_state_names := [ ]
	var to_state_name := ""
	for from_state in transition_item_resource.from_states:
		from_state_names.append(from_state.resource_path.get_file().get_basename().capitalize())
	if has_to_state:
		to_state_name = transition_item_resource.to_state.resource_path.get_file().get_basename().capitalize()
	
	title = "%s -> %s" % [ from_state_names, to_state_name ]
	if not (not transition_item_resource.from_states.empty() and has_to_state):
		self_modulate = Color.crimson
	elif transition_item_resource.conditions.empty():
		self_modulate = Color.coral
	else:
		self_modulate = Color.white


func _add_condition_usage_node(condition_usage_resource: ConditionUsageResource) -> ConditionUsage:
	var condition_usages := $ConditionUsages
	var new_hbox := HBoxContainer.new()
	var new_condition_usage_node: ConditionUsage = ConditionUsageScene.instance()
	var new_menu_button := MenuButton.new()
	
	new_hbox.size_flags_vertical = 0
	new_hbox.add_child(new_condition_usage_node)
	new_hbox.add_child(new_menu_button)
	new_menu_button.name = _MENU_BUTTON_NAME
	
	new_menu_button.text = "..."
	var menu_popup := new_menu_button.get_popup()
	menu_popup.add_icon_item(preload("res://addons/state_machine/icons/icon_plain_arrow_up_16.png"), "Move Up", MenuButtons.MOVE_UP)
	menu_popup.add_icon_item(preload("res://addons/state_machine/icons/icon_plain_arrow_down_16.png"), "Move Down", MenuButtons.MOVE_DOWN)
	menu_popup.add_separator()
	menu_popup.add_icon_item(preload("res://addons/state_machine/icons/icon_trash_can_16.png"), "Delete", MenuButtons.DELETE)
	menu_popup.connect("id_pressed", self, "_on_menu_button_pressed", [ new_hbox ])
	
	condition_usages.add_child(new_hbox)
	new_condition_usage_node.condition_usage_resource = condition_usage_resource
	_update_style()
	
	return new_condition_usage_node

func _update_menu_buttons() -> void:
	var condition_usages := $ConditionUsages.get_children()
	for i in condition_usages.size():
		var hbox: HBoxContainer = condition_usages[i]
		var menu_popup: PopupMenu = hbox.get_node(_MENU_BUTTON_NAME).get_popup()
		menu_popup.set_item_disabled(0, i == 0)
		menu_popup.set_item_disabled(1, i == condition_usages.size() - 1)

func _has_condition(condition: StateConditionResource) -> ConditionUsage:
	for child in $ConditionUsages.get_children():
		var condition_usage: ConditionUsage = child.get_node("ConditionUsage")
		if condition_usage.condition_usage_resource.condition == condition:
			return condition_usage
	return null


func _on_operator_changed(new_operator: int) -> void:
	transition_item_resource.operator = new_operator


func _on_condition_files_selected(paths: PoolStringArray) -> void:
	for path in paths:
		_on_condition_file_selected(path)

func _on_condition_file_selected(path: String) -> void:
	var new_condition := load(path)
	if not (new_condition and new_condition is StateConditionResource):
		$Node/ConditionFileDialog.current_path = _first_condition_path()
		$Node/AcceptDialog.popup_centered()
		return
	
	var new_condition_usage := ConditionUsageResource.new()
	new_condition_usage.condition = new_condition
	
	var condition: StateConditionResource = new_condition_usage.condition
	if _has_condition(condition):
		print("Condition <%s> is already in the node!" % condition.resource_path.get_file().get_basename().capitalize())
		return
	
	transition_item_resource.conditions.append(new_condition_usage)
	_add_condition_usage_node(new_condition_usage)
	_update_menu_buttons()


func _on_menu_button_pressed(id: int, hbox: HBoxContainer) -> void:
	var condition_usages := $ConditionUsages
	var index := condition_usages.get_children().find(hbox)
	
	match id:
		MenuButtons.MOVE_UP:
			condition_usages.move_child(hbox, index - 1)
			transition_item_resource.conditions.insert(index - 1, transition_item_resource.conditions.pop_at(index))
		MenuButtons.MOVE_DOWN:
			condition_usages.move_child(hbox, index + 1)
			transition_item_resource.conditions.insert(index + 1, transition_item_resource.conditions.pop_at(index))
		MenuButtons.DELETE:
			var confirmation: ConfirmationDialog = $Node/ConditionDeleteConfirmationDialog
			confirmation.connect("confirmed", self, "_on_condition_deleted", [ index, hbox ], CONNECT_ONESHOT)
			confirmation.popup_centered()
	
	_update_menu_buttons()

func _on_condition_deleted(index: int, node: HBoxContainer) -> void:
	transition_item_resource.conditions.remove(index)
	$ConditionUsages.remove_child(node)
	node.queue_free()
	_update_style()


func _on_deleted() -> void:
	emit_signal("delete_requested")


func set_transition_item_resource(new_transition_item_resource: TransitionItemResource) -> void:
	transition_item_resource = new_transition_item_resource
	
	var condition_usages := $ConditionUsages
	for child in condition_usages.get_children():
		condition_usages.remove_child(child)
		child.queue_free()
	
	for condition_usage in transition_item_resource.conditions:
		_add_condition_usage_node(condition_usage)
	
	$HBoxContainer/Operator.update_style(transition_item_resource.operator)
	$Node/ConditionFileDialog.current_path = _first_condition_path()
	_update_menu_buttons()
	_update_style()


func _first_condition_path() -> String:
	if transition_item_resource.conditions.empty():
		return ""
	return transition_item_resource.conditions.front().condition.resource_path
