class_name Workstation
extends Area


export(Resource) var _available_job
export(Resource) var _available_tool

export(Resource) var _register_job_channel
export(Resource) var _register_worker_channel


var _current_worker = null #: Controller



func _ready() -> void:
	_register_job()



func apply_for_job(worker) -> bool:
	if _current_worker:
		return false
	
	_unregister_job()
	_current_worker = worker
	_current_worker.current_job = Job.new(self, _available_job, _available_tool)
	return true



func _register_job() -> void:
	# warning-ignore:return_value_discarded
	_register_worker_channel.connect("raised", self, "apply_for_job")
	_register_job_channel.raise(self)

func _unregister_job() -> void:
	_register_worker_channel.disconnect("raised", self, "apply_for_job")




class Job:
	var employer: Workstation
	var job_machine: TransitionTableResource
	var tool_resource: ToolResource
	
	func _init(new_employer: Workstation, new_job_machine: TransitionTableResource, new_tool_resource: ToolResource) -> void:
		employer = new_employer
		job_machine = new_job_machine
		tool_resource = new_tool_resource
