class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppet_master.svg"
extends InputMaster


const SCENE := "res://game_objects/game_actors/actor_controllers/puppet_master.tscn"

const PERSIST_PROPERTIES_2 := ["_applied"]
const PERSIST_OBJ_PROPERTIES_2 := ["_jobs", "_current_job", "_quarter_master"]


var _jobs: Array = [ ]
var _current_job: JobMachine = null

var _applied: bool = false


onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




func _process(_delta: float):
	if not _current_job and not _applied:
		_quarter_master.apply_for_job(self)
		_applied = true




func assign_job(new_job: JobMachine):
	if _current_job:
		_current_job.deactive()
	
	_current_job = new_job
	_jobs.push_front(_current_job)
	
	add_child(_current_job)




func _get_input() -> Array:
	var commands: Array = [ ]
	
	if _current_job:
		var task_target: Node2D = _current_job.current_target()
		
		if task_target and _in_range(task_target):
			commands.append(_current_job.next_command())
			return commands
		
		commands.append(MoveCommand.new(_current_job.next_step()))
	else:
		commands.append(MoveCommand.new(Vector2()))
	
	
	return commands
