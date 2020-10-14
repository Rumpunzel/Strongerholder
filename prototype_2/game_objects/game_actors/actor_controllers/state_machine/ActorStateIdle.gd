class_name ActorStateIdle, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends ActorState




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func enter():
	_change_animation(IDLE)
