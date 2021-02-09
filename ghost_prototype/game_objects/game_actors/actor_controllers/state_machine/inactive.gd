class_name ActorStateInactive, "res://class_icons/states/icon_state.svg"
extends ActorState




func _ready() -> void:
	name = INACTIVE




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("active_state_set", false)


func exit(next_state: String, parameters: Array = [ ]) -> void:
	emit_signal("active_state_set", true)
	
	.exit(next_state, parameters)



func damage(_damage_points: float) -> float:
	return 0.0


func is_active() -> bool:
	return false


func move_to(_direction: Vector2, _is_sprinting: bool) -> void:
	pass


func give_item(_item: GameResource, _receiver: Node2D) -> void:
	pass


func take_item(_item: GameResource) -> void:
	pass


func request_item(_request: Node2D, _receiver: Node2D) -> void:
	pass


func attack(_weapon: CraftTool) -> void:
	pass
