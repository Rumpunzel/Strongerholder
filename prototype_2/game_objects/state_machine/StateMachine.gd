class_name StateMachine, "res://assets/icons/icon_state_machine.svg"
extends Node


export var hit_points_max: float = 10.0
export var indestructible: bool = false


var current_state: ObjectState = null

var history: Array = [ ]


onready var hit_points: float = hit_points_max




# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the initial state to the first child node
	current_state = get_child(0)
	yield(get_tree(), "idle_frame")
	_enter_state()




func change_to(new_state: String, parameters: Array = [ ]):
	current_state.exit(new_state, parameters)


func back():
	if history.size() > 0:
		current_state = get_node(history.pop_back())
		_enter_state()



func damage(damage_points: float, sender) -> bool:
	hit_points -= current_state.damage(damage_points, sender)
	
	#print("%s damaged %s for %s damage." % [sender.name, name, damage_points])
	
	if not indestructible and hit_points <= 0:
		die(sender)
		return false
	
	return true


func die(_sender):
	change_to(ObjectState.DEAD)



func _change_to(new_state: String, parameters: Array = [ ]):
	history.append(current_state.name)
	
	current_state = get_node(new_state)
	_enter_state(parameters)


func _enter_state(parameters: Array = [ ]):
	current_state.enter(parameters)
