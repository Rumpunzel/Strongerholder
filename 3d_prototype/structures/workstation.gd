class_name Workstation, "res://editor_tools/class_icons/spatials/icon_anvil.svg"
extends Stash


export(Resource) var _produces
export var _needs_how_many := 1
export var _operation_steps := 1

export(Resource) var _available_job
export(Resource) var _available_tool

export(Resource) var _register_job_channel
export(Resource) var _register_worker_channel


var _current_worker = null #: Controller
var _current_operation_steps := 0



func _ready() -> void:
	_register_job()



func apply_for_job(worker) -> bool:
	if _current_worker:
		return false
	
	_unregister_job()
	_current_worker = worker
	_current_worker.current_job = Job.new(self, _available_job, _available_tool)
	return true


func can_be_operated() -> bool:
	return _inventory.count(item_to_store) >= _needs_how_many

func operate() -> void:
	assert(can_be_operated())
	_current_operation_steps += 1
	print("Operated")
	_is_operation_complete()

func _is_operation_complete() -> void:
	if _current_operation_steps >= _operation_steps:
		for _i in range(_needs_how_many):
			# warning-ignore:return_value_discarded
			_inventory.remove(item_to_store)
		
		_spawn_item(_produces)

func _spawn_item(item: ItemResource) -> void:
	# warning-ignore:unsafe_property_access
	var spawn_position: Vector3 = owner.translation + Vector3((randf() - 0.5) * 5.0, 5.0, (randf() - 0.1) * 5.0)
	# warning-ignore:return_value_discarded
	item.drop_at(spawn_position)


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
