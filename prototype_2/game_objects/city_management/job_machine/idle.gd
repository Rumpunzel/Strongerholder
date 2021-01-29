class_name JobStateIdle
extends JobState


const PERSIST_OBJ_PROPERTIES_2 := ["_delivery_target"]


var _delivery_target: PilotMaster = null

var _update_time: int = 20
var _timed_passed: int = 0




func _ready():
	name = IDLE




func _check_for_exit_conditions():
	_timed_passed += 1
	
	if _timed_passed < _update_time:
		return
	
	_timed_passed = 0
	
	
	yield(get_tree(), "idle_frame")
	
	if employee.carry_weight_left() <= 0.0:
		exit(DELIVER, [_delivery_target])
		return
	
	var nearest_storage: Node2D = _navigator.nearest_in_group(employer.global_position, CityPilotMaster.STORAGE)
	
	if nearest_storage:
		for use in dedicated_tool.delivers:
			if not (_job_items().empty() or use == _job_items().front().type):
				continue
			
			if _construct_new_plan(use, nearest_storage._pilot_master):
				return
	
	
	if employer.can_be_operated() and employer.get_parent().position_open():
		exit(OPERATE, [employer.get_parent()])
		print("oping")
		return
	
	
	if employee.carry_weight_left() > 0.0:
		for use in dedicated_tool.gathers:
			if not (_job_items().empty() or use == _job_items().front().type):
				continue
			
			if _construct_new_plan(use, employer):
				return
	
	
	if not _job_items().empty():
		exit(DELIVER, [_delivery_target])
		return




func enter(parameters: Array = [ ]):
	assert(parameters.size() <= 1)
	
	if parameters.empty():
		_delivery_target = null
	else:
		_delivery_target = parameters[0]
		#assert(_delivery_target)
	
	_timed_passed = 0
	
	.enter(parameters)


func exit(next_state: String, parameters: Array = [ ]):
	_delivery_target = null
	
	.exit(next_state, parameters)



func _construct_new_plan(use, delivery_target: Node2D) -> bool:
	var nearest_resource: GameResource = _get_nearest_item_of_type(use)
	
	if nearest_resource:
		exit(PICK_UP, [nearest_resource, delivery_target])
		return true
	
	
	var nearest_structure: Structure = _get_nearest_structure_holding_item_of_type(use, [delivery_target.get_parent().type])
	
	if nearest_structure:
		var state: String = GATHER
		
		if nearest_structure is CityStructure:
			if nearest_structure.can_be_gathered(use):
				state = RETRIEVE
			else:
				return false
		
		exit(state, [use, nearest_structure, delivery_target])
		return true
	
	return false
