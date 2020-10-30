class_name ActorStateMachine, "res://assets/icons/game_actors/states/icon_actor_state_machine.svg"
extends ObjectStateMachine


const PERSIST_PROPERTIES_3 := ["animation_tree_node"]


var animation_tree_node: String


var _checked_animation: bool = false
var _update_time: int = 20
var _timed_passed: int = 0

# warning-ignore-all:unused_class_variable
var _puppet_master: InputMaster

var _animation_tree: AnimationStateMachine




func _setup_states(state_classes: Array = [ ]):
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


func _ready():
	_animation_tree = get_node(animation_tree_node)
	
	_animation_tree.connect("acted", self, "_animation_acted")
	_animation_tree.connect("action_finished", self, "_action_finished")
	_animation_tree.connect("animation_finished", self, "_animation_finished")


func _process(_delta: float):
	if _checked_animation:
		return
	
	_timed_passed += 1
	
	if _timed_passed < _update_time:
		return
	
	_timed_passed = 0
	
	var current_animation: String = _animation_tree.get_current_animation()
	
	if not current_state._animation_cancellable and not (current_animation == ActorState.ATTACK or current_animation == ActorState.GIVE):
		current_state.animtion_finished(current_animation)
	
	_checked_animation = true




func move_to(direction: Vector2, is_sprinting: bool = false):
	current_state.move_to(direction, is_sprinting)


func give_item(item: GameResource, receiver: Node2D):
	current_state.give_item(item, receiver)


func take_item(item: GameResource):
	current_state.take_item(item)


func request_item(request, receiver: Node2D):
	current_state.request_item(request, receiver)


func attack(weapon: CraftTool):
	current_state.attack(weapon)


func operate(structure: Node2D):
	current_state.operate(structure)



func _change_to(new_state: String, parameters: Array = [ ]):
	._change_to(new_state, parameters)
	
	_timed_passed = 0


func _change_animation(new_animation: String, new_direction: Vector2 = Vector2()):
	if _animation_tree.get_current_animation() == new_animation:
		_animation_acted(new_animation)
		_animation_finished(new_animation)
	else:
		_animation_tree.travel(new_animation)
	
	if not new_direction == Vector2():
		_animation_tree.blend_positions = Vector2(new_direction.x * 0.9, new_direction.y)



func _animation_acted(animation: String):
	current_state.animation_acted(animation)


func _action_finished(animation: String):
	current_state.action_finished(animation)


func _animation_finished(animation: String):
	current_state.animtion_finished(animation)
