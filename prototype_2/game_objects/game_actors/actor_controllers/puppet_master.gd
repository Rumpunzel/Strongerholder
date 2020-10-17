class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppet_master.svg"
extends InputMaster


const TASK_MASTER = "task_master"
const TASK_TARGET = "task_target"
const PURPOSE = "purpose"
const TOOL = "tool"


var _current_plan: BasicPlan = null
var _current_job: JobQueue.JobPosting = null

var _current_application: WorkerQueue.WorkerProfile = null


onready var _inventory: Inventory = $inventory
onready var _tool_belt: ToolBelt = $tool_belt

onready var _navigator: Navigator = ServiceLocator.navigator
onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




func _process(_delta: float):
	if not (_current_plan and _current_plan.is_useful() and not _current_application):
		if _current_job:
			_current_job.unassign_worker(self)
			_current_job = null
		
		_current_application = _quarter_master.apply_for_job(self, _inventory, _tool_belt)




func new_basic_plan(new_task_location: Vector2) :
	var new_path = _navigator.get_simple_path(global_position, new_task_location)
	#print("\n%s:\ncurrent_path: %s\n" % [owner.name, new_path])
	
	_current_plan = BasicPlan.new(self, new_path)
	_current_application = null


func new_plan(new_task_master: Node2D, new_task_target: Node2D, new_purpose, new_tool: Node2D, new_job: JobQueue.JobPosting):
	var new_path = _navigator.get_simple_path(global_position, new_task_target.global_position)
	#print("\n%s:\ncurrent_path: %s\n" % [owner.name, new_path])
	
	_current_job = new_job
	_current_plan = Plan.new(self, new_path, new_task_master, new_task_target, new_purpose, new_tool)
	_current_application = null



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
	
	var purpose
	var task_tool: Node2D
	
	
	func _init(new_task_agent: PuppetMaster, new_path: PoolVector2Array, new_task_master: Node2D, new_task_target: Node2D, new_purpose, new_tool: Node2D).(new_task_agent, new_path):
		task_master = new_task_master
		task_target = new_task_target
		
		purpose = new_purpose
		task_tool = new_tool
	
	
	
	func next_command() -> InputMaster.Command:
		if task_target == task_master:
			task_target = null
			path = PoolVector2Array()
			
			return InputMaster.GiveCommand.new(task_tool, task_master)
		
		if task_target.type == purpose:
			return InputMaster.TakeCommand.new(task_target)
		
		return InputMaster.AttackCommand.new(task_tool)
	
	
	
	func is_useful() -> bool:
		return .is_useful() or _targets_active()
	
	func _targets_active() -> bool:
		return task_master and task_target and task_master.is_active() and task_target.is_active()
