class_name GameActor, "res://class_icons/game_objects/game_actors/icon_game_actor.svg"
extends KinematicBody2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true
const SCENE := "res://game_objects/game_actors/game_actor.tscn"

const PERSIST_PROPERTIES := [
	"name",
	"position",
	"type",
	"sprite",
	"hit_points_max",
	"indestructible",
	"hit_points",
	"move_speed",
	"sprint_modifier",
	"velocity",
	"player_controlled",
	"_first_time"
]
const PERSIST_OBJ_PROPERTIES := [ "_puppet_master", "_state_machine" ]


signal moved(direction)

signal died
signal damaged


# warning-ignore:unused_class_variable
var type: String
var sprite: String setget set_sprite

var hit_points_max: float
var indestructible: bool
var hit_points: float

var selected: bool = false setget set_selected


var move_speed: float = 64.0
var sprint_modifier: float = 2.0

var velocity: Vector2 = Vector2()
var player_controlled: bool = false


var _first_time: bool = true
var _puppet_master: InputMaster
var _state_machine: ActorStateMachine


onready var _collision_shape: CollisionShape2D = $CollisionShape
onready var _sprite: Sprite = $Sprite
onready var _animation_tree: ActorSpriteTree = $Sprite/AnimationTree




func _ready() -> void:
	if _first_time:
		_first_time = false
		
		hit_points = hit_points_max
		
		_initialisation()
	
	_connect_state_machine()
	
	set_sprite(sprite)
	
	# warning-ignore:unsafe_property_access
	$StateLabel._state_machine = _state_machine
	# warning-ignore:unsafe_property_access
	$JobLabel._puppet_master = _puppet_master
	# warning-ignore:unsafe_property_access
	$EmployerLabel._puppet_master = _puppet_master


func _process(_delta: float) -> void:
	_puppet_master.process_commands(_state_machine, player_controlled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity)
	
	if not velocity == Vector2():
		emit_signal("moved", velocity)




func transfer_item(item: GameResource, reciever) -> bool:
	if _puppet_master.in_range(reciever):
		return reciever.recieve_transferred_item(item)
	
	return false


func recieve_transferred_item(item: GameResource) -> bool:
	return _puppet_master.recieve_transferred_item(item)



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
	emit_signal("died")


func is_active() -> bool:
	return _state_machine.is_active()


func enable_collision(new_status: bool) -> void:
	_collision_shape.set_deferred("disabled", not new_status)



func set_velocity(new_velocity: Vector2, sprinting: bool) -> void:
	velocity = new_velocity * move_speed * (sprint_modifier if sprinting else 1.0)

func set_sprite(new_sprite: String):
	sprite = new_sprite
	
#	if _sprite:
#		_sprite.texture = load(sprite)
#		_sprite.offset.y = -_sprite.texture.get_height() / 2.0

func set_selected(new_status: bool) -> void:
	selected = new_status
	#_selection_outline.visible = selected




func _initialisation() -> void:
	_initialise_puppet_master()
	_initialise_state_machine()


func _initialise_puppet_master(new_puppet_master: PackedScene = load("res://game_objects/game_actors/actor_controllers/puppet_master.tscn") as PackedScene) -> void:
	_puppet_master = new_puppet_master.instance()
	add_child(_puppet_master)


func _initialise_state_machine(new_state_machine: ActorStateMachine = ActorStateMachine.new()) -> void:
	_state_machine = new_state_machine
	
	add_child(_state_machine)


func _connect_state_machine() -> void:
	_state_machine.connect("animation_changed", self, "_on_animation_changed")
	_state_machine.connect("died", self, "_on_died")
	
	_state_machine.connect("moved", self, "set_velocity")
	_state_machine.connect("gave_item_to", self, "transfer_item")
	_state_machine.connect("dropped_item", _puppet_master, "drop_item")
	_state_machine.connect("took_item", _puppet_master, "pick_up_item")
	_state_machine.connect("item_requested", self, "_on_item_requested")
	_state_machine.connect("attacked", self, "_on_attacked")
	_state_machine.connect("operated_structure", _puppet_master, "interact_with")
	
	_animation_tree.connect("acted", _state_machine, "_animation_acted")
	_animation_tree.connect("action_finished", _state_machine, "_action_finished")
	_animation_tree.connect("animation_finished", _state_machine, "_animation_finished")



func _on_animation_changed(new_animation: String, new_direction: Vector2) -> void:
	if _animation_tree.get_current_animation() == new_animation:
		_state_machine._animation_acted(new_animation)
		_state_machine._animation_finished(new_animation)
	else:
		_animation_tree.travel(new_animation)
	
	if not new_direction == Vector2():
		_animation_tree.blend_positions = Vector2(new_direction.x * 0.9, new_direction.y)


func _on_item_requested(request: String, structure_to_request_from: CityStructure) -> void:
	if _puppet_master.has_inventory_space_for(GameClasses.get_script_constant_map()[request]) and _puppet_master.in_range(structure_to_request_from):
		structure_to_request_from.request_item(request, self)

func _on_attacked(weapon: CraftTool) -> void:
	weapon.start_attack(self)
