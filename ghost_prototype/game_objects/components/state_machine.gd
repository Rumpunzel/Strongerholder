class_name StateMachine
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := [ "history", "_first_time" ]
const PERSIST_OBJ_PROPERTIES := [ "current_state" ]


const MAXIMUM_HISTORY_LENGTH: int = 32


signal state_changed


var current_state: State = null

var history: Array = [ ]


var _first_time: bool = true




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "StateMachine"
	
	_setup_states()
	
	yield(get_tree(), "idle_frame")
	
	_connect_states()
	
	assert(current_state)
	
	_enter_state()




func change_to(new_state: String, parameters: Array = [ ]) -> void:
	current_state.exit(new_state, parameters)


func back() -> void:
	if history.size() > 0:
		current_state = get_node(history.pop_front())
		_enter_state()



func is_active() -> bool:
	return current_state.is_active()



func _change_to(new_state: String, parameters: Array = [ ]) -> void:
	var old_state: String = current_state.name
	
	while history.size() >= MAXIMUM_HISTORY_LENGTH:
		history.pop_back()
	
	history.push_front(old_state)
	#print("%s entering %s" % [owner.name, new_state])
	current_state = get_node(new_state)
	_enter_state(parameters)
	
	emit_signal("state_changed", current_state, old_state)


func _enter_state(parameters: Array = [ ]) -> void:
	current_state.enter(parameters)



func _setup_states(state_classes: Array = [ ]) -> void:
	if _first_time:
		_first_time = false
		
		for state in state_classes:
			var new_state = state.new()
			add_child(new_state)
	
	# Set the initial state to the first child node
	if not current_state:
		current_state = get_child(0)


func _connect_states() -> void:
	pass

