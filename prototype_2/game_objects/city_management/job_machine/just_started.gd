class_name JobStateJustStarted, "res://assets/icons/game_actors/states/icon_state_just_started.svg"
extends JobStateRetrieve




func _ready():
	name = JUST_STARTED




func enter(_parameters: Array = [ ]):
	.exit(RETRIEVE, [dedicated_tool.type, employer.get_parent(), null])
