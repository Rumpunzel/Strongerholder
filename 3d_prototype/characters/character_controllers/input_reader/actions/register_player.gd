extends ActionLeaf

export var _unregister_on_exit := true

export(Resource) var _player_registered_channel
export(Resource) var _player_unregistered_channel

var _character: Character

func on_update(blackboard: OccupationBlackboard) -> int:
	_character = blackboard.character
	# warning-ignore-all:unsafe_property_access
	_player_registered_channel.raise(_character)
	return Status.SUCCESS

func _exit_tree() -> void:
	if _unregister_on_exit:
		# warning-ignore-all:unsafe_property_access
		_player_unregistered_channel.raise(_character)
