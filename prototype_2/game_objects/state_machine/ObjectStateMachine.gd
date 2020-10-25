class_name ObjectStateMachine, "res://assets/icons/icon_state_machine.svg"
extends StateMachine


const PERSIST_PROPERTIES_2 := ["hit_points_max", "indestructible", "hit_points"]


signal damaged(damage_points, sender)


export var hit_points_max: float = 10.0
export var indestructible: bool = false


onready var hit_points: float = hit_points_max



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
