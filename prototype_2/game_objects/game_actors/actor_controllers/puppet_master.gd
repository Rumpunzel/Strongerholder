class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppet_master.svg"
extends InputMaster


const PERSIST_PROPERTIES_2 := ["_applied"]
const PERSIST_OBJ_PROPERTIES_2 := ["_jobs", "_current_job"]


var _jobs: Array = [ ]
var _current_job = null

var _applied: bool = false


onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




func assign_job(new_job) -> void:
	if _current_job:
		_current_job.deactive()
	
	_applied = false
	_current_job = new_job
	_jobs.push_front(_current_job)
	
	add_child(_current_job)




func _get_input(player_controlled: bool) -> Array:
	if player_controlled:
		return ._get_input(player_controlled)
	
	var commands: Array = [ ]
	
	if _current_job:
		var task_target: Node2D = _current_job.current_target()
		var next_step: Vector2 = _current_job.next_step()
		
		if task_target and in_range(task_target):
			commands.append(_current_job.next_command())
			return commands
		
		commands.append(MoveCommand.new(next_step))
	else:
		if not _applied:
			_quarter_master.apply_for_job(self)
			_applied = true
		
		commands.append(MoveCommand.new(Vector2()))
	
	
	return commands



func _initialise_inventories() -> void:
	var new_tool_belt: ToolBelt = ToolBelt.new()
	new_tool_belt.name = "tool_belt"
	add_child(new_tool_belt)
	_inventories.append(new_tool_belt)
	
	._initialise_inventories()
