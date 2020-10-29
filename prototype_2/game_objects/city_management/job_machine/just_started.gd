class_name JobStateJustStarted, "res://assets/icons/game_actors/states/icon_state_just_started.svg"
extends JobStateRetrieve




func _ready():
	name = JUST_STARTED




func enter(parameters: Array = [ ]):
	if not parameters.empty():
		assert(parameters.size() == 1)
	
	.exit(RETRIEVE, [parameters[0], employer.get_parent(), null])
