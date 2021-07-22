class_name LookForWorkActionResource
extends StateActionResource

export(Resource) var _register_worker_channel
export(Resource) var _register_job_channel

func _create_action() -> StateAction:
	return LookForWorkAction.new(_register_worker_channel, _register_job_channel)


class LookForWorkAction extends StateAction:
	var _state_machine: Node#: Controller
	var _register_worker_channel: NodeEventChannelResource
	var _register_job_channel: NodeEventChannelResource
	
	
	func _init(register_worker_channel: NodeEventChannelResource, register_job_channel: NodeEventChannelResource) -> void:
		_register_worker_channel = register_worker_channel
		_register_job_channel = register_job_channel
	
	
	func awake(state_machine: Node) -> void:
		_state_machine = state_machine
	
	
	func on_state_enter() -> void:
		# warning-ignore:return_value_discarded
		_register_job_channel.connect("raised", self, "_on_job_posted")
		_register_worker_channel.raise(_state_machine)
	
	func on_state_exit() -> void:
		_register_job_channel.disconnect("raised", self, "_on_job_posted")
	
	
	func _on_job_posted(workstation) -> void:
		if not weakref(_state_machine).get_ref():
			return
		
		var got_a_job: bool = workstation.apply_for_job(_state_machine)
		if got_a_job:
			on_state_exit()
