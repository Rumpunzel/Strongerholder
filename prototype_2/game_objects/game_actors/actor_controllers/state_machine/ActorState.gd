class_name ActorState, "res://assets/icons/game_actors/states/icon_state.svg"
extends Node


const IDLE = "idle"
const RUN = "run"


onready var game_actor = owner
onready var state_machine = get_parent()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func enter():
	pass


func exit(next_state: String):
	state_machine.change_to(next_state)



func move_to(direction: Vector2, _is_sprinting: bool):
	exit(RUN)



func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()):
	state_machine._change_animation(new_animation, new_direction)
