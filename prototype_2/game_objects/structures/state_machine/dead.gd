class_name CityStructureStateDead, "res://assets/icons/icon_state_dead.svg"
extends CityStructureInactive




func _ready() -> void:
	name = DEAD




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	game_object.die()


func exit(_next_state: String, _parameters: Array = [ ]) -> void:
	pass

