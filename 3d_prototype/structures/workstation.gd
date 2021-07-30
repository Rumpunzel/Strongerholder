class_name Workstation, "res://editor_tools/class_icons/spatials/icon_anvil.svg"
extends Stash

signal operated()
signal produced()

export var _needs_how_many := 1
export var _operation_steps_per_item := 1

export(Resource) var _produces

export var _produces_how_many_per_step := 1

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
	_current_worker.current_job = Job.new(self, _available_job, _available_tool, _item_to_store, _produces)
	return true


func can_be_operated() -> bool:
	return _current_operation_steps > 0 or inventory.count(_item_to_store) >= _needs_how_many

func could_be_operated(employee_inventory: CharacterInventory) -> bool:
	return can_be_operated() or employee_inventory.count(_item_to_store) + inventory.count(_item_to_store) >= _needs_how_many

func operate() -> void:
	_current_operation_steps += 1
	
	if _current_operation_steps % _operation_steps_per_item == 1:
		# warning-ignore:return_value_discarded
		inventory.remove(_item_to_store)
	elif _current_operation_steps % _operation_steps_per_item == 0:
		_produce()
	
	if _current_operation_steps >= _operation_steps_per_item * _needs_how_many:
		_current_operation_steps = 0
	
	emit_signal("operated")


func save_to_var(save_file: File) -> void:
	save_file.store_8(_current_operation_steps)

func load_from_var(save_file: File) -> void:
	_current_operation_steps = save_file.get_8()



func _produce() -> void:
	for _i in range(_produces_how_many_per_step):
		# warning-ignore:return_value_discarded
		inventory.add(_produces)
	
	emit_signal("produced")


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
	
	var gathers: ItemResource
	var delivers: ItemResource
	
	func _init(_employer: Workstation, _job_machine: TransitionTableResource, _tool_resource: ToolResource, _gathers: ItemResource, _delivers: ItemResource) -> void:
		employer = _employer
		job_machine = _job_machine
		tool_resource = _tool_resource
		
		gathers = _gathers
		delivers = _delivers
