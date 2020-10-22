class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppet_master.svg"
extends InputMaster


const TASK_MASTER = "task_master"
const TASK_TARGET = "task_target"
const PURPOSE = "purpose"
const TOOL = "tool"


var _current_plan: BasicPlan = null
var _current_job: JobQueue.JobPosting = null

var _current_application: WorkerQueue.WorkerProfile = null


onready var _navigator: Navigator = ServiceLocator.navigator
onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




func _process(_delta: float):
	if not _current_job and not _current_application:
		_current_application = _quarter_master.apply_for_job(self, _inventories)
		
#	if not (_current_plan and _current_plan.is_useful()):
#		if _current_plan:
#			_current_plan = null
#
#		if _current_job:
#			_current_job.unassign_worker(self)
#			_current_job = null
#		elif not _current_application:
#




func new_basic_plan(new_task_location: Vector2) :
	var new_path = _navigator.get_simple_path(global_position, new_task_location)
	#print("\n%s:\ncurrent_path: %s\n" % [owner.name, new_path])
	
	_current_plan = BasicPlan.new(self, new_path)
	_quarter_master.unapply_for_job(_current_application)
	_current_application = null


func new_plan(new_task_master: Node2D, new_task_target: Node2D, new_purpose, new_tool: Node2D, new_job: JobQueue.JobPosting):
	var new_path = _navigator.get_simple_path(global_position, new_task_target.global_position)
	#print("\n%s:\ncurrent_path: %s\n" % [owner.name, new_path])
	
	_current_job = new_job
	_current_plan = Plan.new(self, new_path, new_task_master, new_task_target, new_purpose, new_tool)
	_quarter_master.unapply_for_job(_current_application)
	_current_application = null




func _get_input() -> Array:
	var commands: Array = [ ]
	
	if _current_plan:
		var task_target: Node2D = _current_plan.task_target
		
		if task_target and _in_range(task_target):
			commands.append(_current_plan.next_command())
			return commands
		
		commands.append(MoveCommand.new(_current_plan.next_step()))
	else:
		commands.append(MoveCommand.new(Vector2()))
	
	
	return commands





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
	
	
	func _to_string() -> String:
		return "\nTask Agent: %s\nPath: %s\n" % [task_agent, path]



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
		var target_interact_with: Node2D = task_target
		
		if target_interact_with == task_master:
			_invalidate_plan()
			return InputMaster.GiveCommand.new(task_tool, target_interact_with)
		
		if target_interact_with.type == purpose:
			_invalidate_plan()
			return InputMaster.TakeCommand.new(target_interact_with)
		
		if target_interact_with is CityStructure:
			_invalidate_plan()
			return InputMaster.RequestCommand.new(purpose, target_interact_with)
		
		return InputMaster.AttackCommand.new(task_tool)
	
	
	func is_useful() -> bool:
		return .is_useful() and _targets_active()
	
	
	func _targets_active() -> bool:
		return task_master and task_target and task_master.is_active() and task_target.is_active()
	
	func _invalidate_plan():
		task_target = null
		path = PoolVector2Array()
	
	
	func _to_string() -> String:
		return "%sTask Master: %s\nTask Target: %s\nPurpose: %s\nTask Tool: %s\n" % [._to_string(), task_master.name if task_master else "NULL", task_target.name if task_target else "NULL", purpose, task_tool.name if task_tool else "NULL"]
