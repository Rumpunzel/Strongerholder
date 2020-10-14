class_name StateMachine, "res://assets/icons/game_actors/states/icon_state_machine.svg"
extends Node


export (NodePath) var _animation_tree_node


var current_state: ActorState = null

var history: Array = [ ]


onready var animation_tree: AnimationStateMachine = get_node(_animation_tree_node)




# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the initial state to the first child node
	current_state = get_child(0)
	yield(get_tree(), "idle_frame")
	_enter_state()




func change_to(new_state: String):
	history.append(current_state.name)
	
	current_state = get_node(new_state)
	_enter_state()


func back():
	if history.size() > 0:
		current_state = get_node(history.pop_back())
		_enter_state()



func move_to(direction: Vector2, is_sprinting: bool = false):
	current_state.move_to(direction, is_sprinting)



func _enter_state():
	current_state.enter()


func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()):
	animation_tree.travel(new_animation)
	
	if not new_direction == Vector2():
		animation_tree.blend_positions = new_direction
