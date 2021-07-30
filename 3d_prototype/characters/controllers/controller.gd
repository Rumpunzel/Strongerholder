class_name Controller, "res://editor_tools/class_icons/nodes/icon_brain.svg"
extends StateMachine

var current_job: Workstation.Job = null setget _set_current_job

# warning-ignore:unsafe_method_access
onready var _inventory: CharacterInventory = Utils.find_node_of_type_in_children(owner, CharacterInventory)


func _unhandled_input(event: InputEvent) -> void:
	if _current_state:
		_current_state.on_input(event)


func save_to_var(save_file: File) -> void:
	# Store node path
	if current_job:
		save_file.store_var(current_job.employer.get_path())
	else:
		save_file.store_var("")

func load_from_var(save_file: File) -> void:
	# Load node path
	var path_to_employer: String = save_file.get_var()
	var employer: Workstation = get_node_or_null(path_to_employer)
	if employer:
		# warning-ignore:return_value_discarded
		employer.apply_for_job(self)


func _set_current_job(new_job) -> void:
	current_job = new_job
	# warning-ignore:return_value_discarded
	_inventory.add(current_job.tool_resource)
	
	if _current_state:
		_current_state.on_state_exit()
	
	_transition_table_resource = current_job.job_machine
	_start()
