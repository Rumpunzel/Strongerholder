class_name GameObject
extends StaticBody2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := [
	"name",
	"position",
	"type",
	"sprite_sheets",
	"maximum_operators",
	"damaged_sounds",
	"_current_sprite_sheet",
	"_first_time",
]
const PERSIST_OBJ_PROPERTIES := [
	"_state_machine",
	"_object_stats",
	"_assigned_workers",
]


signal selected

signal damaged
signal died


var type: String
var sprite_sheets: Array

var hit_points_max: float setget set_hit_points_max, get_hit_points_max
var hit_points: float setget set_hit_points, get_hit_points
var indestructible: bool setget set_indestructible, get_indestructible

var maximum_operators: int

var damaged_sounds: String setget set_damaged_sounds


var selected: bool = false setget set_selected


var _first_time: bool = true
var _state_machine: ObjectStateMachine
var _object_stats: GameObjectStats
var _current_sprite_sheet: String setget set_current_sprite_sheet

var _assigned_workers: Array = [ ]


onready var _collision_shape: CollisionShape2D = $CollisionShape
onready var _sprite: GameSprite = $Sprite
onready var _selection_outline: SelectionOutline = $SelectionOutline
onready var _audio_handler: AudioHandler = $AudioHandler




func _ready() -> void:
	if _first_time:
		_first_time = false
		
		_initialisation()
	
	_connect_state_machine()
	_initialise_deferred_components()
	
	connect("damaged", _audio_handler, "play_damage_audio")
	
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
	var damage_taken: float = _object_stats.damage(_state_machine.damage(damage_points))
	
	emit_signal("damaged", damage_taken, sender)
	#print("%s damaged %s for %s damage." % [sender.name, name, damage_points])
	
	if _object_stats.is_dead():
		die()
		return false
	
	return true


func die() -> void:
	_state_machine.die()



func is_active() -> bool:
	return _state_machine.is_active()


func enable_collision(new_status: bool) -> void:
	_collision_shape.set_deferred("disabled", not new_status)




func set_hit_points_max(new_max: float) -> void:
	hit_points_max = new_max
	
	if _object_stats:
		_object_stats.hit_points_max = hit_points_max

func set_hit_points(new_hit_points: float) -> void:
	hit_points = new_hit_points
	
	if _object_stats:
		_object_stats.hit_points = hit_points

func set_indestructible(new_status: bool) -> void:
	indestructible = new_status
	
	if _object_stats:
		_object_stats.indestructible = indestructible


func set_damaged_sounds(new_sounds: String) -> void:
	damaged_sounds = new_sounds
	
	if _audio_handler:
		_audio_handler.set_damaged_sounds(damaged_sounds)


func set_selected(new_status: bool) -> void:
	selected = new_status
	_selection_outline.visible = selected
	
	emit_signal("selected", self if selected else null)


func set_current_sprite_sheet(new_sheet: String) -> void:
	_current_sprite_sheet = new_sheet
	_sprite.texture = load(_current_sprite_sheet)



func get_hit_points_max() -> float:
	if _object_stats:
		hit_points_max = _object_stats.hit_points_max
	
	return hit_points_max

func get_hit_points() -> float:
	if _object_stats:
		hit_points = _object_stats.hit_points
	
	return hit_points

func get_indestructible() -> bool:
	if _object_stats:
		indestructible = _object_stats.indestructible
	
	return indestructible



func _initialisation() -> void:
	_initialise_state_machine()
	_initialise_object_stats()
	_initialise_game_sprite()

func _initialise_deferred_components() -> void:
	set_damaged_sounds(damaged_sounds)



func _initialise_state_machine(new_state_machine: ObjectStateMachine = ObjectStateMachine.new()) -> void:
	_state_machine = new_state_machine
	add_child(_state_machine)


func _connect_state_machine() -> void:
	_state_machine.connect("active_state_set", self, "_on_active_state_set")
	_state_machine.connect("died", self, "_on_died")


func _initialise_object_stats(new_object_stats := GameObjectStats.new()) -> void:
	_object_stats = new_object_stats
	_object_stats.name = "ObjectStats"
	
	set_hit_points_max(hit_points_max)
	set_indestructible(indestructible)
	
	add_child(_object_stats)


func _initialise_game_sprite() -> void:
	set_current_sprite_sheet(sprite_sheets[ randi() % sprite_sheets.size() ])



func _on_active_state_set(new_state: bool) -> void:
	appear(new_state)
	enable_collision(new_state)
	
	set_process(new_state)
	set_physics_process(new_state)

func _on_died() -> void:
	_on_active_state_set(false)
	
	emit_signal("died")
