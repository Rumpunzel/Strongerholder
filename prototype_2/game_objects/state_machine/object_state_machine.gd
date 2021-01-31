class_name ObjectStateMachine, "res://assets/icons/icon_state_machine.svg"
extends StateMachine


const PERSIST_PROPERTIES_2 := ["hit_points_max", "indestructible", "hit_points"]
const PERSIST_OBJ_PROPERTIES_2 := ["game_object"]


signal damaged(damage_points, sender)


var game_object: Node2D = null

var hit_points_max: float = 10.0
var indestructible: bool = false

var hit_points: float




func _setup_states(state_classes: Array = [ ]) -> void:
	if _first_time:
		hit_points = hit_points_max
	
	._setup_states(state_classes)
	
	for state in get_children():
		state.state_machine = self
		state.game_object = game_object




func damage(damage_points: float, sender) -> bool:
	var damage_taken: float = current_state.damage(damage_points, sender)
	
	hit_points -= damage_taken
	
	emit_signal("damaged", damage_taken, sender)
	#print("%s damaged %s for %s damage." % [sender.name, name, damage_points])
	
	if not indestructible and hit_points <= 0:
		die(sender)
		return false
	
	return true


func die(_sender) -> void:
	change_to(ObjectState.DEAD)
