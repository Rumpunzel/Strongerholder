class_name ActorStateRun, "res://assets/icons/game_actors/states/icon_state_run.svg"
extends ActorState


export var move_speed: float = 64.0
export var sprint_modifier: float = 2.0


var sprinting: bool = false setget set_sprinting

# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var _movement_modifier: float = 1.0




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func exit(next_state: String):
	game_actor.velocity = Vector2()
	
	.exit(next_state)



func move_to(direction: Vector2, is_sprinting: bool):
	if direction == Vector2():
		exit(IDLE)
		return
	
	set_sprinting(is_sprinting)
	
	game_actor.velocity = direction.normalized() * move_speed * _movement_modifier
	
	_change_animation(RUN, direction)




func set_sprinting(new_status: bool):
	sprinting = new_status
	_movement_modifier = sprint_modifier if sprinting else 1.0
