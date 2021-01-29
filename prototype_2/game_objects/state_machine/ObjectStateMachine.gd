class_name ObjectStateMachine, "res://assets/icons/icon_state_machine.svg"
extends StateMachine


const PERSIST_PROPERTIES_2 := ["hit_points_max", "indestructible", "hit_points"]


signal damaged(damage_points, sender)


var hit_points_max: float = 10.0
var indestructible: bool = false

var hit_points: float




func _setup_states(state_classes: Array = [ ]):
	if _first_time:
		hit_points = hit_points_max
	
	._setup_states(state_classes)




func damage(damage_points: float, sender) -> bool:
	var damage_taken: float = current_state.damage(damage_points, sender)
	
	hit_points -= damage_taken
	
	emit_signal("damaged", damage_taken, sender)
	#print("%s damaged %s for %s damage." % [sender.name, name, damage_points])
	
	if not indestructible and hit_points <= 0:
		die(sender)
		return false
	
	return true


func die(_sender):
	change_to(ObjectState.DEAD)
