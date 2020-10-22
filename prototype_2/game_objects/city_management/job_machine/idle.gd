class_name JobStateIdle
extends JobState




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	var nearest_storage: Node2D = _navigator.nearest_in_group(employer.global_position, CityPilotMaster.STORAGE)
	
	if nearest_storage:
		for use in dedicated_tool.delivers:
			if _construct_new_plan(use, nearest_storage._pilot_master):
				return
	
	for use in dedicated_tool.gathers:
		if _construct_new_plan(use, employer):
			return




func _construct_new_plan(use, delivery_target: Node2D) -> bool:
	var nearest_resource: GameResource = _get_nearest_item_of_type(use)
	
	if nearest_resource:
		exit(PICK_UP, [nearest_resource, delivery_target])
		return true
	
	
	var nearest_structure: Structure = _get_nearest_structure_holding_item_of_type(use, [delivery_target.owner.type])
	
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
