class_name GameActor
extends GameObject


signal new_interest(object_of_interest)
signal acquired_target(currently_searching_for)


export var player_controlled: int = 0 setget , get_player_controlled


var object_of_interest: GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for


onready var body: KinematicBody = $body
onready var behavior: ActorBehavior = $behavior
onready var animation_tree: AnimationTree = $animation_tree
onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")




func _ready():
	$pathfinder.register_actor(self)


func _process(_delta):
	if can_act():
		acquire_new_target()




func setup(new_ring_map: RingMap):
	.setup(new_ring_map)
	
	$pathfinder.ring_map = ring_map


func listen_to_commands(new_commands):
	for command in new_commands:
		if command.execute(self):
			break


func move_to(direction: Vector3, sprinting: bool = false):
	.set_ring_vector(body.move_to(direction, sprinting))


func animate(animation: String, stop_movement: bool = true):
	if stop_movement:
		move_to(Vector3())
	
	state_machine.travel(animation)


func acquire_new_target():
	set_currently_searching_for(behavior.next_priority(inventory))


func can_act() -> bool:
	var state: String = state_machine.get_current_node()
	var is_idle: bool = state.ends_with("idle") or state == "run"
	
	return is_idle




func set_player_controlled(new_player: int, new_camera = preload("res://prefabs/gameactors/player/PlayerCamera.tscn").instance()):
	if new_player > 0:
		$pathfinder.unregister_actor(self)
		$pathfinder.set_script(load("res://prefabs/gameactors/player/InputMaster.gd"))
		$pathfinder.ring_map = ring_map
		$pathfinder.register_actor(self)
		behavior.blank_prios()
		add_child(new_camera)
		new_camera.set_node_to_follow(body)
	else:
		$pathfinder.unregister_actor(self)
		$pathfinder.set_script(load("res://prefabs/gameactors/PuppetMaster.gd"))
		$pathfinder.ring_map = ring_map
		$pathfinder.register_actor(self)
	
	player_controlled = new_player


func set_object_of_interest(new_object: GameObject):
	if not new_object == object_of_interest:
		object_of_interest = new_object
		emit_signal("new_interest", object_of_interest)


func set_currently_searching_for(new_interest):
	if not new_interest == currently_searching_for:
		currently_searching_for = new_interest
		emit_signal("acquired_target", currently_searching_for)


func set_ring_vector(new_vector: RingVector):
	$body.ring_vector = new_vector
	.set_ring_vector($body.ring_vector)



func get_player_controlled() -> int:
	return player_controlled

func get_object_of_interest() -> GameObject:
	return object_of_interest

func get_currently_searching_for():
	return currently_searching_for

func get_ring_vector() -> RingVector:
	return $body.ring_vector
