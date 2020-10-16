class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppet_master.svg"
extends InputMaster


const TASK_MASTER = "task_master"
const TASK_TARGET = "task_target"
const PURPOSE = "purpose"
const TOOL = "tool"


var _current_plan: BasicPlan


onready var _inventory: Inventory = $inventory
onready var _tool_belt: ToolBelt = $tool_belt

onready var _navigation: Navigation2D = ServiceLocator.navigation




func _process(_delta: float):
	if not (_current_plan and _current_plan.is_useful()):
		var master_purpose: Dictionary = _search_task_master()
		
		var new_task_master: Node2D = master_purpose.get(TASK_MASTER)
		var new_task_target: Node2D = master_purpose.get(TASK_TARGET)
		var new_purpose = master_purpose.get(PURPOSE)
		var new_tool: Node2D = master_purpose.get(TOOL)
		
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


func new_plan(new_task_master: Node2D, new_task_target: Node2D, new_purpose: String, new_tool: Node2D):
	var new_path = _navigation.get_simple_path(global_position, new_task_target.global_position)
	print("\n%s:\ncurrent_path: %s\n" % [owner.name, new_path])
	
	_current_plan = Plan.new(self, new_path, new_task_master, new_task_target, new_purpose, new_tool)



func pick_up_item(item: GameResource) -> bool:
	if _in_range(item):
		_inventory.pick_up_item(item)
		return true
	
	return false


func drop_item(item: GameResource, position_to_drop: Vector2 = global_position):
	_inventory.drop_item(item, position_to_drop)

func drop_all_items(position_to_drop: Vector2 = global_position):
	_inventory.drop_all_items(position_to_drop)




func _get_input() -> Array:
	var commands: Array = [ ]
	
	if _current_plan:
		var task_target: Node2D = _current_plan.task_target
		
		if task_target and _in_range(task_target):
			commands.append(_current_plan.next_command())
			return commands
		
		commands.append(MoveCommand.new(_current_plan.next_step()))
	
	return commands



func _search_task_master() -> Dictionary:
	for item in _inventory.get_contents():
		var item_type: String = Constants.enum_name(Constants.Resources, item.type)
		var nearest_master: Node2D = _nearest_in_group("%s%s" % [Constants.REQUEST, item_type])
		
		if nearest_master:
			return { TASK_MASTER: nearest_master, TASK_TARGET: nearest_master, PURPOSE: item_type, TOOL: item }
	
	
	for craft_tool in _tool_belt.get_tools():
		for use in craft_tool.used_for:
			var tool_type: String = Constants.enum_name(Constants.Resources, use)
			var nearest_master: Node2D = _nearest_in_group("%s%s" % [Constants.REQUEST, tool_type])
			
			if nearest_master:
				return { TASK_MASTER: nearest_master, PURPOSE: tool_type, TOOL: craft_tool }
	
	return { }



func _search_task_target(task_master: Node2D, purpose: String) -> Node2D:
	return _nearest_in_group(purpose, [ task_master.type ])



func _nearest_in_group(group_name: String, groups_to_exclude: Array = [ ]) -> Node2D:
	var group: Array = get_tree().get_nodes_in_group(group_name)
	var nearest_object: Node2D = null
	var shortest_distance: float = INF
	
	# Check that the potential target's type is actually requested
	for object in group:
		if not object.is_active():
			continue
		
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




func _in_range(object: PhysicsBody2D):
	return get_overlapping_bodies().has(object)





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
		return path.size() > 1



class Plan extends BasicPlan:
	
	var task_master: Node2D
	var task_target: Node2D
	
	var purpose: String
	var task_tool: Node2D
	
	
	func _init(new_task_agent: PuppetMaster, new_path: PoolVector2Array, new_task_master: Node2D, new_task_target: Node2D, new_purpose: String, new_tool: Node2D).(new_task_agent, new_path):
		task_master = new_task_master
		task_target = new_task_target
		
		purpose = new_purpose
		task_tool = new_tool
	
	
	
	func next_command() -> InputMaster.Command:
		if task_target == task_master:
			task_target = null
			path = PoolVector2Array()
			return InputMaster.GiveCommand.new(task_tool, task_master)
		
		if Constants.enum_name(Constants.Resources, task_target.type) == purpose:
			return InputMaster.TakeCommand.new(task_target)
		
		return InputMaster.AttackCommand.new(task_tool)
	
	
	
	func is_useful() -> bool:
		return .is_useful() or _targets_active()
	
	func _targets_active() -> bool:
		return task_master and task_target and task_master.is_active() and task_target.is_active()
