class_name JobStateJustStarted, "res://assets/icons/game_actors/states/icon_state_just_started.svg"
extends JobStateRetrieve



func enter(parameters: Array = [ ]):
	.enter([dedicated_tool.type, employer, null])
