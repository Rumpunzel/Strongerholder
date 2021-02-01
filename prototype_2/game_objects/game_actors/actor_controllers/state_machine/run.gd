class_name ActorStateRun, "res://class_icons/game_actors/states/icon_state_run.svg"
extends ActorState


const PERSIST_PROPERTIES_3 := ["move_speed", "sprint_modifier"]


export var move_speed: float = 64.0
export var sprint_modifier: float = 2.0


var sprinting: bool = false setget set_sprinting

# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var _movement_modifier: float = 1.0




func _ready() -> void:
	name = RUN




func exit(next_state: String, parameters: Array = [ ]) -> void:
	game_object.velocity = Vector2()
	
	.exit(next_state, parameters)



func move_to(direction: Vector2, is_sprinting: bool) -> void:
	if direction == Vector2():
		exit(IDLE)
		return
	
	set_sprinting(is_sprinting)
	
	game_object.velocity = direction.normalized() * move_speed * _movement_modifier
	
	_change_animation(RUN, direction)




func set_sprinting(new_status: bool) -> void:
	sprinting = new_status
	_movement_modifier = sprint_modifier if sprinting else 1.0
