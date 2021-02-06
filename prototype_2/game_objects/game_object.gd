class_name GameObject
extends StaticBody2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name", "position", "type", "sprite", "hit_points_max", "indestructible", "maximum_operators", "_first_time"]
const PERSIST_OBJ_PROPERTIES := ["_assigned_workers", "_state_machine"]


signal died
signal damaged


var type: String
var sprite: String setget set_sprite

var hit_points_max: float
var indestructible: bool
var hit_points: float

var maximum_operators: int

var selected: bool = false setget set_selected


var _first_time: bool = true
var _state_machine: ObjectStateMachine

var _assigned_workers: Array = [ ]


onready var _collision_shape: CollisionShape2D = $CollisionShape
onready var _sprite: Sprite = $Sprite
onready var _selection_outline: SelectionOutline = $SelectionOutline

onready var _objects_layer = ServiceLocator.objects_layer




func _ready() -> void:
	if _first_time:
		_first_time = false
		
		hit_points = hit_points_max
		
		_initialisation()
	
	_connect_state_machine()
	
	add_to_group(type)


func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("select_object"):
		get_tree().set_input_as_handled()
		set_selected(true)

# TODO: kind of a hack to get deselecting to work atm
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select_object"):
		set_selected(false)




func assign_worker(puppet_master: Node2D) -> void:
	if not _assigned_workers.has(puppet_master):
		_assigned_workers.append(puppet_master)
	assert(_assigned_workers.size() <= maximum_operators)


func unassign_worker(puppet_master: Node2D) -> void:
	_assigned_workers.erase(puppet_master)


func position_open(puppet_master: Node2D) -> bool:
	return worker_assigned(puppet_master) or _assigned_workers.size() < maximum_operators


func worker_assigned(puppet_master: Node2D) -> bool:
	return _assigned_workers.has(puppet_master) 



func appear(new_status: bool) -> void:
	visible = new_status


func damage(damage_points: float, sender) -> bool:
	if indestructible:
		return false
	
	var damage_taken: float = _state_machine.damage(damage_points)
	
	hit_points -= damage_taken
	
	emit_signal("damaged", damage_taken, sender)
	#print("%s damaged %s for %s damage." % [sender.name, name, damage_points])
	
	if hit_points <= 0:
		die()
		return false
	
	return true


func die() -> void:
	_state_machine.die()



func is_active() -> bool:
	return _state_machine.is_active()


func enable_collision(new_status: bool) -> void:
	_collision_shape.set_deferred("disabled", not new_status)




func set_sprite(new_sprite: String):
	sprite = new_sprite
	$Sprite.texture = load(sprite)
	$Sprite.offset.y = -$Sprite.texture.get_height() / 2.0


func set_selected(new_status: bool) -> void:
	selected = new_status
	_selection_outline.visible = selected



func _initialisation() -> void:
	_initialise_state_machine()


func _initialise_state_machine(new_state_machine: ObjectStateMachine = ObjectStateMachine.new()) -> void:
	_state_machine = new_state_machine
	_state_machine.name = "StateMachine"
	
	add_child(_state_machine)


func _connect_state_machine() -> void:
	_state_machine.connect("active_state_set", self, "_on_active_state_set")
	_state_machine.connect("died", self, "_on_died")



func _on_active_state_set(new_state: bool) -> void:
	appear(new_state)
	enable_collision(new_state)
	
	set_process(new_state)
	set_physics_process(new_state)

func _on_died() -> void:
	_on_active_state_set(false)
	
	emit_signal("died")
