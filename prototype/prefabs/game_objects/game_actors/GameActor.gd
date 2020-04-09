class_name GameActor
extends GameObject


signal new_interest(object_of_interest)
signal acquired_target(currently_searching_for)


export(PackedScene) var player_camera

export var player_controlled: int = 0 setget , get_player_controlled


var object_of_interest: GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for


var pathfinder: PuppetMaster
var behavior: ActorBehavior


onready var body: KinematicBody = $body

onready var animation_tree: AnimationTree = $animation_tree
onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")




func _process(_delta):
	if can_act():
		acquire_new_target()




func setup(new_ring_map: RingMap, new_ring_vector:RingVector, controlling_player: int = 0):
	.setup(new_ring_map, new_ring_vector)
	
	behavior = ActorBehavior.new()
	
	set_player_controlled(controlling_player)


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




func set_player_controlled(new_player: int):
	if new_player > 0 and not player_controlled:
		if pathfinder:
			pathfinder.queue_free()
		
		behavior.set_priorities(CityLayout.Objects.NOTHING, CityLayout.Objects.NOTHING, CityLayout.Objects.NOTHING)
		
		pathfinder = InputMaster.new(ring_map, self)
		add_child(pathfinder)
		
		var new_camera = player_camera.instance()
		add_child(new_camera)
		new_camera.set_node_to_follow($body)
	else:
		if pathfinder:
			pathfinder.queue_free()
		
		behavior.set_priorities(CityLayout.Objects.TREE, CityLayout.Objects.STOCKPILE, CityLayout.Objects.NOTHING)
		
		pathfinder = PuppetMaster.new(ring_map, self)
		add_child(pathfinder)
		#add_child(new_camera)
		#new_camera.set_node_to_follow(body)
	
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
