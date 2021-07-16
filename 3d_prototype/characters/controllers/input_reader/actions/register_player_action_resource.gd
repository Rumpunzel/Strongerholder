class_name RegisterPlayerActionResource
extends StateActionResource

# warning-ignore:unused_class_variable
export var unregister_on_exit := true

# warning-ignore:unused_class_variable
export(Resource) var player_registered_channel
# warning-ignore:unused_class_variable
export(Resource) var player_unregistered_channel


func _create_action() -> StateAction:
	return RegisterPlayerActions.new()



class RegisterPlayerActions extends StateAction:
	var _character: Character
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	func on_state_enter() -> void:
		# warning-ignore-all:unsafe_property_access
		origin_resource.player_registered_channel.raise(_character)
	
	func on_state_exit() -> void:
		# warning-ignore-all:unsafe_property_access
		if origin_resource.unregister_on_exit:
			# warning-ignore-all:unsafe_property_access
			origin_resource.player_unregistered_channel.raise(_character)
