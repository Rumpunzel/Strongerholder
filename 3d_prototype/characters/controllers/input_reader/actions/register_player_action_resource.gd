class_name RegisterPlayerActionResource
extends StateActionResource

export var _unregister_on_exit := true

func _create_action() -> StateAction:
	return RegisterPlayerActions.new(_unregister_on_exit)


class RegisterPlayerActions extends StateAction:
	var _character: Character
	var _unregister_on_exit: bool
	
	
	func _init(unregister_on_exit: bool) -> void:
		_unregister_on_exit = unregister_on_exit
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	
	func on_state_enter() -> void:
		Events.player.emit_signal("player_registered", _character)
	
	func on_state_exit() -> void:
		if _unregister_on_exit:
			Events.player.emit_signal("player_unregistered", _character)
