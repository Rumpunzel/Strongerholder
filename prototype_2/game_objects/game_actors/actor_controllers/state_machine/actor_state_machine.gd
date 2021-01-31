class_name ActorStateMachine, "res://assets/icons/game_actors/states/icon_actor_state_machine.svg"
extends ObjectStateMachine


const PERSIST_PROPERTIES_3 := ["animation_tree_node"]
const PERSIST_OBJ_PROPERTIES_3 := ["puppet_master"]


var animation_tree_node: String

# warning-ignore-all:unused_class_variable
var puppet_master: InputMaster


var _checked_animation: bool = false

var _animation_tree: AnimationStateMachine




func _setup_states(state_classes: Array = [ ]) -> void:
	if state_classes.empty():
		state_classes = [
			ActorStateIdle,
			ActorStateRun, 
			ActorStateGive,
			ActorStateTake,
			ActorStateRequest,
			ActorStateAttack,
			ActorStateOperate,
			ActorStateInactive,
			ActorStateDead,
		]
	
	._setup_states(state_classes)
	
	for state in get_children():
		state.puppet_master = puppet_master


func _ready() -> void:
	_animation_tree = get_node(animation_tree_node)
	
	_animation_tree.connect("acted", self, "_animation_acted")
	_animation_tree.connect("action_finished", self, "_action_finished")
	_animation_tree.connect("animation_finished", self, "_animation_finished")


func _process(_delta: float) -> void:
	if _checked_animation:
		return
	
	var current_animation: String = _animation_tree.get_current_animation()
	
	if not current_state._animation_cancellable and not (current_animation == ActorState.ATTACK or current_animation == ActorState.GIVE):
		current_state.animtion_finished(current_animation)
	
	_checked_animation = true




func move_to(direction: Vector2, is_sprinting: bool = false) -> void:
	current_state.move_to(direction, is_sprinting)


func give_item(item: GameResource, receiver: Node2D) -> void:
	current_state.give_item(item, receiver)


func take_item(item: GameResource) -> void:
	current_state.take_item(item)


func request_item(request, receiver: Node2D) -> void:
	current_state.request_item(request, receiver)


func transfer_item(item, receiver: Node2D) -> void:
	current_state.transfer_item(item, receiver)


func attack(weapon: CraftTool) -> void:
	current_state.attack(weapon)


func operate(structure: Node2D) -> void:
	current_state.operate(structure)




func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()) -> void:
	if _animation_tree.get_current_animation() == new_animation:
		_animation_acted(new_animation)
		_animation_finished(new_animation)
	else:
		_animation_tree.travel(new_animation)
	
	if not new_direction == Vector2():
		_animation_tree.blend_positions = Vector2(new_direction.x * 0.9, new_direction.y)



func _animation_acted(animation: String) -> void:
	current_state.animation_acted(animation)


func _action_finished(animation: String) -> void:
	current_state.action_finished(animation)


func _animation_finished(animation: String) -> void:
	current_state.animtion_finished(animation)
