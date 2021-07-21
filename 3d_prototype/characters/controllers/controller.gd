class_name Controller, "res://editor_tools/class_icons/nodes/icon_brain.svg"
extends StateMachine

var current_job = null setget _set_current_job

# warning-ignore:unsafe_method_access
onready var _inventory: CharacterInventory = Utils.find_node_of_type_in_children(owner, CharacterInventory)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.editor_hint:
		return
	
	_current_state.on_input(event)


func save_to_var(save_file: File) -> void:
	# Store resource path
	save_file.store_var(_transition_table_resource.resource_path)

func load_from_var(save_file: File) -> void:
	# Load as resource
	var resource_path: String = save_file.get_var()
	var loaded_table: TransitionTableResource = load(resource_path)
	assert(loaded_table)
	set_transition_table_resource(loaded_table)


func _set_current_job(new_job) -> void:
	current_job = new_job
	# warning-ignore:return_value_discarded
	_inventory.add(current_job.tool_resource)
	set_transition_table_resource(current_job.job_machine)
