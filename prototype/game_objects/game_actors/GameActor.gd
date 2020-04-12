class_name GameActor
extends RingObject


export(PackedScene) var player_camera

export var player_controlled: int = -1 setget , get_player_controlled


var can_act: bool = true setget set_can_act, get_can_act


var pathfinder: PuppetMaster


onready var game_character: GameCharacter = $game_character




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
	.set_ring_vector(game_character.move_to(direction, sprinting))


func animate(animation: String, stop_movement: bool = true):
	game_character.animate(animation, stop_movement)


func is_in_range(object_of_interest) -> bool:
	return game_character.is_in_range(object_of_interest)




func set_player_controlled(new_player: int):
	if not new_player == player_controlled:
		if new_player > 0 and player_controlled <= 0:
			if pathfinder:
				pathfinder.queue_free()
			
			pathfinder = InputMaster.new(ring_map, self)
			
			var new_camera = player_camera.instance()
			add_child(new_camera)
			new_camera.set_node_to_follow($game_character)
		else:
			if pathfinder:
				pathfinder.queue_free()
			
			pathfinder = PuppetMaster.new(ring_map, self)
			#add_child(new_camera)
			#new_camera.set_node_to_follow(body)
		
		add_child(pathfinder)
		
		player_controlled = new_player


func set_can_act(new_status: bool):
	can_act = new_status

func set_ring_vector(new_vector: RingVector):
	$game_character.ring_vector = new_vector
	.set_ring_vector($game_character.ring_vector)

func set_object_of_interest(new_object: RingObject):
	pathfinder.set_object_of_interest(new_object, false)



func get_player_controlled() -> int:
	return player_controlled

func get_can_act() -> bool:
	if can_act:
		return game_character.is_idle()
	else:
		return can_act

func get_ring_vector() -> RingVector:
	return $game_character.ring_vector

func get_object_of_interest() -> RingObject:
	return pathfinder.object_of_interest

func is_looking_for() -> int:
	return pathfinder.get_currently_looking_for()
