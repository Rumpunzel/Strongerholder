class_name StateMachine
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name", "history", "_first_time"]
const PERSIST_OBJ_PROPERTIES := ["current_state"]


signal state_changed(new_state, old_state)


var current_state = null

var history: Array = [ ]


var _first_time: bool = true




# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_states()




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



func _setup_states(state_classes: Array = [ ]):
	if _first_time:
		_first_time = false
		
		for state in state_classes:
			var new_state = state.new()
			add_child(new_state)
	
	if not current_state:
		# Set the initial state to the first child node
		current_state = get_child(0)
	assert(current_state)
	yield(get_tree(), "idle_frame")
	
	_enter_state()

