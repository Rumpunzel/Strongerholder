class_name StateMachine
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name", "history"]
const PERSIST_OBJ_PROPERTIES := ["current_state"]


signal state_changed(new_state, old_state)


var current_state = null

var history: Array = [ ]




# Called when the node enters the scene tree for the first time.
func _ready():
	#yield(SaveHandler, "game_load_finished")
	
	if not current_state:
		# Set the initial state to the first child node
		current_state = get_child(0)
	
	yield(get_tree(), "idle_frame")
	print(current_state.name)
	_enter_state()




func change_to(new_state: String, parameters: Array = [ ]):
	current_state.exit(new_state, parameters)


func back():
	if history.size() > 0:
		current_state = get_node(history.pop_back())
		_enter_state()



func is_active() -> bool:
	return current_state.is_active()



func _change_to(new_state: String, parameters: Array = [ ]):
	var old_state: String = current_state.name
	
	history.append(old_state)
	#print("%s entering %s" % [owner.name, new_state])
	current_state = get_node(new_state)
	_enter_state(parameters)
	
	emit_signal("state_changed", current_state, old_state)


func _enter_state(parameters: Array = [ ]):
	current_state.enter(parameters)

