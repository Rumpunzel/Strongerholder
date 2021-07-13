class_name Controller
extends StateMachine


func save_to_var(save_file: File) -> void:
	# Store resource path
	save_file.store_var(_transition_table_resource.resource_path)

func load_from_var(save_file: File) -> void:
	# Load as resource
	var resource_path: String = save_file.get_var()
	var loaded_table: TransitionTableResource = load(resource_path)
	assert(loaded_table)
	_transition_table_resource = loaded_table
