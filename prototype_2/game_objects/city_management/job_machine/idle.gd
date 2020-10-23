class_name JobStateIdle
extends JobState



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	yield(get_tree(), "idle_frame")
	
	if employer.can_be_operated() and employer.owner.position_open():
		exit(OPERATE, [employer.owner, _job_items])
		return
	
	
	var nearest_storage: Node2D = _navigator.nearest_in_group(employer.global_position, CityPilotMaster.STORAGE)
	
	if nearest_storage:
		for use in dedicated_tool.delivers:
			if _construct_new_plan(use, nearest_storage._pilot_master):
				return
	
	
	for use in dedicated_tool.gathers:
		if _construct_new_plan(use, employer):
			return
	
	
	if not _job_items.empty():
		exit(DELIVER, [_job_items, employer.owner])
		return




func enter(parameters: Array = [ ]):
	assert(parameters.size() <= 1)
	
	if parameters.empty():
		_job_items = [ ]
	else:
		_job_items = parameters[0]
	
	.enter(parameters)



func _construct_new_plan(use, delivery_target: Node2D) -> bool:
	var nearest_resource: GameResource = _get_nearest_item_of_type(use)
	
	if nearest_resource:
		exit(PICK_UP, [nearest_resource, delivery_target, _job_items])
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
