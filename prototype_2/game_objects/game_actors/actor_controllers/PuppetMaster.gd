class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppeteer.svg"
extends InputMaster


const TASK_MASTER = "task_master"
const TASK_TARGET = "task_target"
const PURPOSE = "purpose"
const TOOL = "tool"


var _current_plan: BasicPlan


onready var _inventory: Inventory = $inventory
onready var _tool_belt: ToolBelt = $tool_belt

onready var _navigation: Navigation2D = get_tree().get_root().get_node("test/navigation")




func _process(_delta: float):
	if not (_current_plan and _current_plan.is_useful()):
		var master_purpose: Dictionary = _search_task_master()
		
		var new_task_master: Object = master_purpose.get(TASK_MASTER)
		var new_task_target: Object = master_purpose.get(TASK_TARGET)
		var new_purpose = master_purpose.get(PURPOSE)
		var new_tool: Object = master_purpose.get(TOOL)
		
		if not (new_task_master and new_purpose):
			return
		
		if not new_task_target:
			new_task_target = _search_task_target(new_task_master, new_purpose)
		
		if not new_task_target:
			return
		
		new_plan(new_task_master, new_task_target, new_purpose, new_tool)



func new_basic_plan(new_task_location: Vector2) :
	var new_path = _navigation.get_simple_path(global_position, new_task_location)
	print("\n%s:\ncurrent_path: %s\n" % [owner.name, new_path])
	
	_current_plan = BasicPlan.new(self, new_path)


func new_plan(new_task_master: Object, new_task_target: Object, new_purpose: String, new_tool: Object):
	var new_path = _navigation.get_simple_path(global_position, new_task_target.global_position)
	print("\n%s:\ncurrent_path: %s\n" % [owner.name, new_path])
	
	_current_plan = Plan.new(self, new_path, new_task_master, new_task_target, new_purpose, new_tool)




func _get_input() -> Array:
	var commands: Array = [ ]
	
	if _current_plan:
		var task_target: Object = _current_plan.task_target
		
		if task_target and get_overlapping_bodies().has(task_target):
			commands.append(_current_plan.next_command())
		
		commands.append(MoveCommand.new(_current_plan.next_step()))
	
	return commands



func _search_task_master() -> Dictionary:
	for item in _inventory.get_contents():
		var item_type: String = Constants.enum_name(Constants.Resources, item.type)
		var nearest_master: Object = _nearest_in_group("%s%s" % [Constants.REQUEST, item_type])
		
		if nearest_master:
			return { TASK_MASTER: nearest_master, PURPOSE: item_type, TOOL: item }
	
	
	for craft_tool in _tool_belt.get_tools():
		for use in craft_tool.used_for:
			var tool_type: String = Constants.enum_name(Constants.Resources, use)
			var nearest_master: Object = _nearest_in_group("%s%s" % [Constants.REQUEST, tool_type])
			
			if nearest_master:
				return { TASK_MASTER: nearest_master, PURPOSE: tool_type, TOOL: craft_tool }
	
	return { }



func _search_task_target(task_master: Object, purpose: String) -> Object:
	return _nearest_in_group(purpose, [ task_master.type ])



func _nearest_in_group(group_name: String, groups_to_exclude: Array = [ ]) -> Object:
	var group: Array = get_tree().get_nodes_in_group(group_name)
	var nearest_object: Object = null
	var shortest_distance: float = INF
	
	# Check that the potential target's type is actually requested
	for object in group:
		var valid_object: bool = true
		var object_groups: Array = object.get_groups()
		
		for ex_group in groups_to_exclude:
			if object_groups.has(Constants.enum_name(Constants.Structures, ex_group)):
				valid_object = false
				break
		
		if not valid_object:
			continue
		
		# Check if the potential target is the nearest one
		var simple_path: PoolVector2Array = _navigation.get_simple_path(global_position, object.global_position)
		var distance_to_body: float = 0.0
		var path_index: int = 0
		
		while path_index < simple_path.size() - 1:
			distance_to_body += simple_path[path_index].distance_to(simple_path[path_index + 1])
			path_index += 1
		
		if distance_to_body < shortest_distance:
			shortest_distance = distance_to_body
			nearest_object = object
	
	return nearest_object





class BasicPlan:
	
	var task_agent: PuppetMaster
	var path: PoolVector2Array
	
	
	func _init(new_task_agent: PuppetMaster, new_path: PoolVector2Array):
		task_agent = new_task_agent
		path = new_path
	
	
	func next_step() -> Vector2:
		while not path.empty() and task_agent.global_position.distance_to(path[0]) <= 1.0:
			path.remove(0)
		
		var movement_vector: Vector2 = Vector2()
		
		if not path.empty():
			movement_vector = path[0] - task_agent.global_position
		
		return movement_vector
	
	
	func is_useful() -> bool:
		return not path.empty()



class Plan extends BasicPlan:
	
	var task_master: Object
	var task_target: Object
	
	var purpose: String
	var task_tool: Object
	
	
	func _init(new_task_agent: PuppetMaster, new_path: PoolVector2Array, new_task_master: Object, new_task_target: Object, new_purpose: String, new_tool: Object).(new_task_agent, new_path):
		task_master = new_task_master
		task_target = new_task_target
		
		purpose = new_purpose
		task_tool = new_tool
	
	
	
	func next_command() -> InputMaster.Command:
		if task_target == task_master:
			return InputMaster.GiveCommand.new(task_target, task_tool)
		
		match task_target:
			_:
				return InputMaster.AttackCommand.new(task_target, task_tool)
	
	
	
	func is_useful() -> bool:
		return .is_useful() or (task_master and task_target)
