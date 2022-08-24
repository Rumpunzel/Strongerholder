class_name StateResource, "res://addons/state_machine/icons/icon_cog.svg"
extends Resource

export(Array, Resource) var _actions


func get_state(state_machine: Node, created_instances: Dictionary) -> State:
	var state: State = created_instances.get(self)
	
	if state:
		return state
	
	state = State.new(
			self,
			state_machine,
			[ ],
			_get_actions(_actions, state_machine, created_instances)
	)
	
	created_instances[self] = state
	
	return state


static func _get_actions(scriptable_actions: Array, state_machine: Node, created_instances: Dictionary) -> Array:
	var actions := [ ]
	
	for action in scriptable_actions:
		actions.append(action.get_action(state_machine, created_instances))
	
	return actions


func _to_string() -> String:
	return resource_path.get_file().get_basename()
