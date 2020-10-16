class_name ActorStateMachine, "res://assets/icons/game_actors/states/icon_actor_state_machine.svg"
extends StateMachine


export (NodePath) var _animation_tree_node


onready var _animation_tree: AnimationStateMachine = get_node(_animation_tree_node)




# Called when the node enters the scene tree for the first time.
func _ready():
	_animation_tree.connect("acted", self, "_animation_acted")
	_animation_tree.connect("action_finished", self, "_action_finished")
	_animation_tree.connect("animation_finished", self, "_animation_finished")




func move_to(direction: Vector2, is_sprinting: bool = false):
	current_state.move_to(direction, is_sprinting)


func give_item(item: Node2D):
	current_state.give_item(item)


func take_item(item: Node2D):
	current_state.take_item(item)


func attack(weapon: CraftTool):
	current_state.attack(weapon)



func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()):
	_animation_tree.travel(new_animation)
	
	if not new_direction == Vector2():
		_animation_tree.blend_positions = new_direction



func _animation_acted(animation: String):
	current_state.animation_acted(animation)


func _action_finished(animation: String):
	current_state.action_finished(animation)


func _animation_finished(animation: String):
	current_state.animtion_finished(animation)

