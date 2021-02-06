class_name JobMachine, "res://class_icons/states/icon_state_machine.svg"
extends StateMachine


const PERSIST_PROPERTIES_2 := ["_debug_flag_scene", "_timed_passed"]
const PERSIST_OBJ_PROPERTIES_2 := ["employee", "employer", "dedicated_tool", "_flag"]


const DebugFlagScene = preload("res://city_management/job_machine/flag.tscn")


var employee: PuppetMaster
var employer: CityStructure
var dedicated_tool: Spyglass


var _update_time: float = 0.3
var _timed_passed: float = 0.0

var _flag: Sprite




func _ready() -> void:
	if not _flag and DebugFlagScene:
		_flag = DebugFlagScene.instance()
		get_tree().current_scene._world.add_child(_flag)


func _setup(new_employer: CityStructure, new_employee: PuppetMaster) -> void:
	employer = new_employer
	employee = new_employee
	
	_flag.target = employee


func _process(delta: float) -> void:
	yield(get_tree(), "idle_frame")
	
	var target: Node2D = current_target()
	
	if target:
		_flag.visible = true
		_flag.global_position = target.global_position
	else:
		_flag.visible = false
	
	
	_timed_passed += delta
	
	if _timed_passed < _update_time:
		return
	
	_timed_passed = 0.0
	
	_check_for_exit_conditions()




func next_step() -> Vector2:
	return current_state.next_step(employee.global_position)

func next_command() -> InputMaster.Command:
	return current_state.next_command(employee, dedicated_tool)

func current_target() -> GameObject:
	return current_state.current_target()



func activate(first_time: bool = false, tool_type = null) -> void:
	current_state.activate(first_time, [ tool_type, employer ])

func deactivate() -> void:
	current_state.deactivate()



func _check_for_exit_conditions() -> void:
	current_state.check_for_exit_conditions(employee, employer, dedicated_tool)


func _setup_states(state_classes: Array = [ ]) -> void:
	if state_classes.empty():
		state_classes = [
			JobStateInactive,
			JobStateJustStarted, 
			JobStateIdle,
			JobStateRetrieve,
			JobStatePickUp,
			JobStateDeliver,
			JobStateGather,
			JobStateOperate,
			JobStateMoveTo,
		]
	
	._setup_states(state_classes)
	print("doing this")
	for state in get_children():
		state.connect("state_changed", self, "_change_to")
		state.connect("items_assigned", self, "_on_items_assigned")
		state.connect("gatherer_assigned", self, "_on_gatherer_assigned")
		state.connect("gatherer_unassigned", self, "_on_gatherer_unassigned")
		state.connect("worker_assigned", self, "_on_worker_assigned")
		state.connect("worker_unassigned", self, "_on_worker_unassigned")


func _change_to(new_state: String, parameters: Array = [ ]) -> void:
	_timed_passed = 0.0
	
	for item in employee.get_inventory_contents(true):
		if weakref(item).get_ref():
			item.unassign_worker(employee)
	
	._change_to(new_state, parameters)

func _on_items_assigned(additional_item: GameResource = null) -> void:
	if additional_item:
		additional_item.assign_worker(employee)
	
	for item in employee.get_inventory_contents(true):
		item.assign_worker(employee)

func _on_gatherer_assigned(structure_to_retrieve_from: CityStructure, item_type: String) -> void:
	structure_to_retrieve_from.assign_gatherer(employee, item_type)

func _on_gatherer_unassigned(structure_to_retrieve_from: CityStructure, item_type: String) -> void:
	structure_to_retrieve_from.unassign_gatherer(employee, item_type)

func _on_worker_assigned(structure_to_gather_from: Structure) -> void:
	structure_to_gather_from.assign_worker(employee)

func _on_worker_unassigned(structure_to_gather_from: Structure) -> void:
	structure_to_gather_from.unassign_worker(employee)
