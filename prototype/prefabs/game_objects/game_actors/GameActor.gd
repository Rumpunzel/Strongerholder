class_name GameActor
extends GameObject


export(PackedScene) var player_camera

export var player_controlled: int = -1 setget , get_player_controlled


var pathfinder: PuppetMaster


onready var body: KinematicBody = $body
onready var area: ActorArea = $body/area

onready var animation_tree: AnimationTree = $animation_tree
onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")




func setup(new_ring_map: RingMap, new_ring_vector: RingVector, new_type: int, controlling_player: int = 0):
	.setup(new_ring_map, new_ring_vector, new_type)
	
	if new_type == Constants.Objects.PLAYER:
		controlling_player = 1
	
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


func can_act() -> bool:
	var state: String = state_machine.get_current_node()
	var is_idle: bool = state.ends_with("idle") or state == "run"
	
	return is_idle


func is_in_range(object_of_interest) -> bool:
	return area.has_object(object_of_interest)




func set_player_controlled(new_player: int):
	if not new_player == player_controlled:
		if new_player > 0 and player_controlled <= 0:
			if pathfinder:
				pathfinder.queue_free()
			
			pathfinder = InputMaster.new(ring_map, self)
			
			var new_camera = player_camera.instance()
			add_child(new_camera)
			new_camera.set_node_to_follow($body)
		else:
			if pathfinder:
				pathfinder.queue_free()
			
			pathfinder = PuppetMaster.new(ring_map, self)
			#add_child(new_camera)
			#new_camera.set_node_to_follow(body)
		
		add_child(pathfinder)
		
		player_controlled = new_player


func set_ring_vector(new_vector: RingVector):
	$body.ring_vector = new_vector
	.set_ring_vector($body.ring_vector)

func set_object_of_interest(new_object: GameObject):
	pathfinder.set_object_of_interest(new_object, false)



func get_player_controlled() -> int:
	return player_controlled

func get_ring_vector() -> RingVector:
	return $body.ring_vector

func get_object_of_interest() -> GameObject:
	return pathfinder.object_of_interest

func is_looking_for() -> int:
	return pathfinder.get_currently_looking_for()
