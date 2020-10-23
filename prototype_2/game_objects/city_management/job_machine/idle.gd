class_name JobStateIdle
extends JobState


var _delivery_target: PilotMaster = null

var _update_time: int = 20
var _timed_passed: int = 0




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	_timed_passed += 1
	
	if _timed_passed < _update_time:
		return
	
	_timed_passed = 0
	
	
	yield(get_tree(), "idle_frame")
	
	_job_items = employee._main_inventory.get_contents()
	
	if employee.carry_weight_left() <= 0:
		exit(DELIVER, [_job_items, _delivery_target])
		return
	
	var nearest_storage: Node2D = _navigator.nearest_in_group(employer.global_position, CityPilotMaster.STORAGE)
	
	if nearest_storage:
		for use in dedicated_tool.delivers:
			if not _job_items.empty() and not use == _job_items.front().type:
				continue
				
			if _construct_new_plan(use, nearest_storage._pilot_master):
				return
	
	
	if employer.can_be_operated() and employer.owner.position_open():
		exit(OPERATE, [employer.owner, _job_items])
		return
	
	
	if employee.carry_weight_left() > 0:
		for use in dedicated_tool.gathers:
			if not _job_items.empty() and not use == _job_items.front().type:
				continue
			
			if _construct_new_plan(use, employer):
				return
	
#	for item in _job_items:
#		print(item.name)
#	exit(DELIVER, [_job_items, _delivery_target])
#	return




func enter(parameters: Array = [ ]):
	assert(parameters.size() == 0 or parameters.size() == 2)
	print(parameters)
	if parameters.empty():
		_job_items = [ ]
		_delivery_target = null
	else:
		# TODO: this is just a dirty fix
		_job_items = parameters[0]
		_delivery_target = parameters[1]
		assert(_delivery_target)
	
	_job_items = employee._main_inventory.get_contents()
	assert(_job_items.size() == employee._main_inventory.get_contents().size())
	_timed_passed = 0
	
	.enter(parameters)


func exit(next_state: String, parameters: Array = [ ]):
	_delivery_target = null
	
	.exit(next_state, parameters)



func _construct_new_plan(use, delivery_target: Node2D) -> bool:
	var nearest_resource: GameResource = _get_nearest_item_of_type(use)
	
	if nearest_resource:
		exit(PICK_UP, [nearest_resource, delivery_target, [ ]])
		return true
	
	
	var nearest_structure: Structure = _get_nearest_structure_holding_item_of_type(use, [delivery_target.owner.type])
	
	if nearest_structure:
		var state: String = GATHER
		
		if nearest_structure is CityStructure:
			if nearest_structure.can_be_gathered(use):
				state = RETRIEVE
			else:
				return false
		
		exit(state, [use, nearest_structure, delivery_target, _job_items])
		return true
	
	return false
