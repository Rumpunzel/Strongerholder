class_name ToolStateDead, "res://class_icons/icon_state_dead.svg"
extends ToolStateInactive




func _ready() -> void:
	name = DEAD




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	game_object.die()


func exit(_next_state: String, _parameters: Array = [ ]) -> void:
	pass



func drop_item(_objects_layer: YSort, _position_to_drop: Vector2) -> void:
	pass


func start_attack(_game_actor: Node2D) -> void:
	pass
