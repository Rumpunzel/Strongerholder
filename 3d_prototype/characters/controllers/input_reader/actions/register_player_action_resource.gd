class_name RegisterPlayerActionResource
extends StateActionResource

export var unregister_on_exit := true

export(Resource) var player_registered_channel
export(Resource) var player_unregistered_channel


func _create_action() -> StateAction:
	return RegisterPlayerActions.new()



class RegisterPlayerActions extends StateAction:
	var _character: Character
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	func on_state_enter() -> void:
		origin_resource.player_registered_channel.raise(_character)
	
	func on_state_exit() -> void:
		if origin_resource.unregister_on_exit:
			origin_resource.player_unregistered_channel.raise(_character)
