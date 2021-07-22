class_name Workstation, "res://editor_tools/class_icons/spatials/icon_anvil.svg"
extends Stash


export(Resource) var _produces
export var _needs_how_many := 1
export var _operation_steps := 1

export(Resource) var _available_job setget _set_available_job
export(Resource) var _available_tool

export(Resource) var _register_job_channel
export(Resource) var _register_worker_channel


var _current_worker: Node = null
var _current_operation_steps := 0



func _enter_tree() -> void:
	add_to_group(SavingAndLoading.PERSIST_DATA_GROUP)

func _process(_delta: float) -> void:
	if _available_job and not _current_worker:
		_register_job()
	
	set_process(false)



func apply_for_job(worker: Node) -> bool:
	if _current_worker:
		return false
	
	_unregister_job()
	_current_worker = worker
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	_current_worker.current_job = Job.new(self, _available_job, _available_tool)
	return true


func can_be_operated() -> bool:
	return _inventory.count(item_to_store) >= _needs_how_many

func operate() -> void:
	assert(can_be_operated())
	_current_operation_steps += 1
	print("Operated")
	_is_operation_complete()


func save_to_var(save_file: File) -> void:
	save_file.store_8(_current_operation_steps)

func load_from_var(save_file: File) -> void:
	_current_operation_steps = save_file.get_8()



func _is_operation_complete() -> void:
	if _current_operation_steps >= _operation_steps:
		for _i in range(_needs_how_many):
			# warning-ignore:return_value_discarded
			_inventory.remove(item_to_store)
		
		_current_operation_steps = 0
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
	if _register_worker_channel.is_connected("raised", self, "apply_for_job"):
		_register_worker_channel.disconnect("raised", self, "apply_for_job")


func _set_available_job(new_job: TransitionTableResource) -> void:
	_available_job = new_job
	set_process(true)



class Job:
	var employer: Workstation
	var job_machine: TransitionTableResource
	var tool_resource: ToolResource
	
	func _init(new_employer: Workstation, new_job_machine: TransitionTableResource, new_tool_resource: ToolResource) -> void:
		employer = new_employer
		job_machine = new_job_machine
		tool_resource = new_tool_resource
