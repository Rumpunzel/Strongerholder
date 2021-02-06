class_name ObjectStateMachine, "res://class_icons/states/icon_state_machine.svg"
extends StateMachine


signal active_state_set
signal died


const PERSIST_PROPERTIES_2 := ["hit_points_max", "indestructible", "hit_points"]


signal damaged(damage_points, sender)


var hit_points_max: float = 10.0
var indestructible: bool = false

var hit_points: float




func _setup_states(state_classes: Array = [ ]) -> void:
	if _first_time:
		hit_points = hit_points_max
	
	._setup_states(state_classes)
	
	for state in get_children():
		state.connect("state_exited", self, "_change_to")
		state.connect("died", self, "_on_died")




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



func _on_died() -> void:
	emit_signal("died")
