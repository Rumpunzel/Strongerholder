class_name ToolStateDead, "res://class_icons/states/icon_state_dead.svg"
extends ToolStateInactive




func _ready() -> void:
	name = DEAD




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("died")


func exit(_next_state: String, _parameters: Array = [ ]) -> void:
	pass



func drop_item(_position_to_drop: Vector2) -> bool:
	return false


func transfer_item() -> bool:
	return false


func start_attack(_game_actor: Node2D) -> void:
	pass
