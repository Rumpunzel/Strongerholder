class_name JobStateIdle
extends JobState


const PERSIST_OBJ_PROPERTIES_2 := ["_delivery_target"]


var _delivery_target: PilotMaster = null




func _ready() -> void:
	name = IDLE




func _check_for_exit_conditions() -> void:
	var job_items: Array = _job_items()
	var job_item: GameObject = job_items.front() if not job_items.empty() else null
	
	# Check if I can carry anything more
	#	 if I cannot, deliver to _delviery_target
	if _delivery_target and employee.carry_weight_left() <= 0.01:
		exit(DELIVER, [_delivery_target])
		return
	
	
	# Check for available storage fo all the resources I deliver with my tools
	for use in dedicated_tool.delivers.keys():
		if not dedicated_tool.delivers[use]:
			continue
		
		var nearest_storage: Node2D = _quarter_master.nearest_storage(employer.global_position, use)
		
		if not nearest_storage or not (job_items.empty() or use == job_items.front().type):
			continue
		
		if _construct_new_plan(use, nearest_storage._pilot_master):
			return
	
	
	# Check if the employer can be operated and do so if possible
	if employer.can_be_operated() and employer_structure.position_open(employee):
		exit(OPERATE, [employer_structure])
		return
	
	
	# Check if there is anything more of what I am currently supposed to be gathering to be had
	for use in dedicated_tool.gathers.keys():
		if not dedicated_tool.gathers[use] or not (job_items.empty() or use == job_item.type):
			continue
		
		if _construct_new_plan(use, employer):
			return
	
	
	# Otherwise, simply return with a delivery to _delivery_target
	if _delivery_target and not job_items.empty():
		exit(DELIVER, [_delivery_target])
		return
	else:
		pass




func enter(parameters: Array = [ ]) -> void:
	assert(parameters.size() <= 1)
	
	if parameters.empty():
		_delivery_target = null
	else:
		_delivery_target = parameters[0]
		#assert(_delivery_target)
	
	.enter(parameters)


func exit(next_state: String, parameters: Array = [ ]) -> void:
	_delivery_target = null
	
	.exit(next_state, parameters)



func _construct_new_plan(use, delivery_target: Node2D) -> bool:
	var nearest_resource: GameResource = _get_nearest_item_of_type(use)
	
	if nearest_resource:
		exit(PICK_UP, [nearest_resource, delivery_target])
		return true
	
	
	var nearest_structure: Structure = _get_nearest_structure_holding_item_of_type(use, [delivery_target.game_object.type])
	
	if nearest_structure:
		var state: String = GATHER
		
		if nearest_structure is CityStructure:
			if nearest_structure.can_be_gathered(use, employee, nearest_structure == employer_structure):
				state = RETRIEVE
			else:
				return false
		
		exit(state, [use, nearest_structure, delivery_target])
		return true
	
	return false
